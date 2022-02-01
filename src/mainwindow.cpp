#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
    , m_isAppendingData(false)
{
    ui->setupUi(this);

    m_db = new Database();
    m_login = new login();

    connect(m_db, &Database::emit_log, this, &MainWindow::catch_log);
    connect(m_login, &login::emit_login_data, this, &MainWindow::onLoginOKClicked);
    connect(ui->actionAbout, &QAction::triggered, this, &MainWindow::onAboutClicked);
    connect(ui->actionExit, &QAction::triggered, this, &MainWindow::onExitClicked);

    ui->tableWidget->horizontalHeader()->setSectionResizeMode(QHeaderView::ResizeToContents);
    ui->queryInput->insertPlainText("SELECT * FROM db.\"zdarzenie\";");
    ui->actionZaloguj_Si->setEnabled(true);
    ui->actionWyloguj_Si->setEnabled(false);
    ui->pushButton->setEnabled(false);
    ui->pushButton_2->setEnabled(false);
    ui->comboBox_specialQ->setEnabled(false);
    ui->spinBox->setEnabled(false);
    ui->lineEdit->setEnabled(false);
    ui->lineEdit_2->setEnabled(false);
    m_logCounter = 0;
    setWindowTitle("Bazy Danych - Projekt");
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::showTable(QString query)
{
    pqxx::result res = m_db->sendQuery(query);

    int cols = 0, rows = 0;
    for (const auto & row : res)
    {
        rows++;
        for (const auto & i : row)
            cols++;
    }

    if (rows == 0 or cols == 0)
    {
        catch_log("Empty table\n", true);
//        return;
    }

    ui->tableWidget->setColumnCount(res.columns());
    ui->tableWidget->setRowCount(rows);



    QStringList labels;
    for (unsigned i = 0; i < res.columns(); i++)
        labels << res.column_name(i);

    ui->tableWidget->setHorizontalHeaderLabels(labels);

    rows = 0;
    for (const auto & row : res)
    {
        cols = 0;
        for (const auto & i : row)
        {
            QTableWidgetItem *newItem = new QTableWidgetItem(QString(i.c_str()));
            ui->tableWidget->setItem(rows, cols, newItem);
            cols++;
        }
        rows++;
    }


}


void MainWindow::catch_log(const QString text, bool red)
{
    if (red)
    ui->appOstream->setTextColor(Qt::red);
    ui->appOstream->insertPlainText(QString::number(++m_logCounter) + ": " + text);
    ui->appOstream->verticalScrollBar()->setValue(ui->appOstream->verticalScrollBar()->maximum());
    ui->appOstream->setTextColor(Qt::black);
}

void MainWindow::onLoginOKClicked()
{
    m_db->setDBName(QString::fromStdString(m_login->getDBName()));
    m_db->setUserName(QString::fromStdString(m_login->getUserName()));
    m_db->setPasswd(QString::fromStdString(m_login->getPasswd()));
    m_db->setHostAddress(QString::fromStdString(m_login->getHostAddress()));
    m_db->setPort(QString::fromStdString(m_login->getPort()));

    m_db->connect();
    if (m_db->isConnected())
    {
        ui->comboBox_table->setEnabled(true);
        ui->pushButton_input->setEnabled(true);
        on_comboBox_table_currentIndexChanged(0);
        ui->pushButton_delete->setEnabled(true);
        ui->actionZaloguj_Si->setEnabled(false);
        ui->actionWyloguj_Si->setEnabled(true);
        ui->pushButton->setEnabled(true);
        ui->pushButton_2->setEnabled(true);
        ui->comboBox_specialQ->setEnabled(true);
        ui->spinBox->setEnabled(true);
        ui->lineEdit->setEnabled(true);
        ui->lineEdit_2->setEnabled(true);
    }

    //    updateTableList();
}

void MainWindow::onAboutClicked() const
{
    QMessageBox msg;
    msg.setWindowTitle("Info");
    msg.setText("Bazy danych 1\nTomasz Madej, 2022");
    msg.exec();
}

void MainWindow::onExitClicked()
{
    QCoreApplication::quit();
}



void MainWindow::on_pushButton_submit_clicked()
{
    QString query = ui->queryInput->toPlainText();
    if (query.split(" ").at(0) == "INSERT" or query.split(" ").at(0) == "insert")
        m_db -> sendQuery(query, true);
    else
        showTable(query);
}

void MainWindow::on_comboBox_table_currentIndexChanged(int index)
{
    ui->pushButton_input->setEnabled(true);
    switch (index)
    {
        case 0:
            m_db -> setSelectedTab("db.\"zdarzenie\"");
        break;
        case 1:
            m_db -> setSelectedTab("db.\"przewinienie\"");
        break;
        case 2:
            m_db -> setSelectedTab("db.\"sad\"");
        break;
        case 3:
            m_db -> setSelectedTab("db.\"uczestnik\"");
        break;
        case 4:
            m_db -> setSelectedTab("db.\"kara\"");
        break;
        case 5:
            m_db -> setSelectedTab("db.\"wiezienie\"");
        break;
        case 6:
            m_db -> setSelectedTab("db.\"osoba\"");
        break;
        case 7:
            m_db -> setSelectedTab("db.\"dowod\"");
        break;
        case 8:
            m_db -> setSelectedTab("db.\"swiadek\"");
        break;
        default:
            m_db -> setSelectedTab("");
        break;
    }

    showTable("SELECT * FROM " + m_db -> getSelectedTab() + ";");

}


void MainWindow::on_pushButton_input_clicked()
{
    if (!m_isAppendingData)
    {
        ui -> tableWidget -> setRowCount(ui->tableWidget->rowCount() + 1);
        ui -> pushButton_save -> setEnabled(true);
        m_isAppendingData = true;
    }

}


void MainWindow::on_pushButton_save_clicked()
{
    QRegularExpression re("^\\d");
    QString values = "";
    QString valNames = "";
    const int cols = ui->tableWidget->columnCount();
    for (int i = 0; i < cols; i++)
    {
        QString curVal = ui->tableWidget->model()->data(ui->tableWidget->model()->index(ui->tableWidget->rowCount()-1, i)).toString();

        if (i == cols - 1)
            if(re.match(curVal).hasMatch())
                values += curVal + " ";
            else if (curVal == "")
                values += "NULL ";
            else
                values += "\'" + curVal + "\' ";

        else
            if(re.match(curVal).hasMatch())
                values += curVal + ", ";
            else if (curVal == "")
                values += "NULL, ";
            else
                values += "\'" + curVal + "\', ";

        valNames += ui->tableWidget->horizontalHeaderItem(i)->text() + " ";
    }



    QString query = "INSERT INTO " + m_db->getSelectedTab() + " (";
    for (int i = 0; i < cols - 1; i++)
        query += valNames.split(" ").at(i) + ", ";
    query += valNames.split(" ").at(cols - 1);
    query += ") VALUES (" + values + ");";

    m_db->sendQuery(query, true);
    ui->pushButton_save->setDisabled(true);
    m_isAppendingData = false;
}





void MainWindow::on_comboBox_tablestretch_activated(int index)
{
    switch (index)
    {
    case 0:
            ui->tableWidget->horizontalHeader()->setSectionResizeMode(QHeaderView::ResizeToContents);
        break;
    case 1:
            ui->tableWidget->horizontalHeader()->setSectionResizeMode(QHeaderView::Interactive);
        break;
    case 2:
            ui->tableWidget->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
        break;
    default:
            ui->tableWidget->horizontalHeader()->setSectionResizeMode(QHeaderView::ResizeToContents);
        break;
    }
}

void MainWindow::on_pushButton_delete_clicked()
{
    QString columnName =  ui->tableWidget->horizontalHeaderItem(0)->text();
    QString indexOfDeletingItem = ui->tableWidget->model()->data(ui->tableWidget->model()->index(ui->tableWidget->currentRow(), 0)).toString();
    QString tableName = ui->comboBox_table->currentText();

    if (indexOfDeletingItem == "")
    {
        catch_log("Please select a row to be removed\n", true);
        return;
    }

    else if (ui->comboBox_table->currentIndex() == 11)
    {
        catch_log("Cannot delete data from view\n", true);
        return;
    }

    QString query = "DELETE FROM " + m_db->getSelectedTab() + " WHERE " + columnName + " = " + indexOfDeletingItem;

    m_db->deleteData(query);
    on_comboBox_table_currentIndexChanged(ui->comboBox_table->currentIndex());
}


void MainWindow::on_pushButton_clearConsole_clicked()
{
    ui->appOstream->clear();
}


void MainWindow::on_comboBox_specialQ_currentIndexChanged(int index)
{
    QString query;
    switch (index)
    {
        case 0:
        query = "select zd.id_zdarzenie as \"ID ZDARZENIA\", zd.nazwa as \"OPIS ZDARZENIA\", count(prz.rodzaj_przewinienia) as \"LICZBA POWIĄZANYCH PRZESTĘPSTW\"\
                from db.\"zdarzenie\" zd , db.\"przewinienie\" prz\
                where zd.id_zdarzenie = prz.id_zdarzenie\
                group by zd.id_zdarzenie;";
        break;
        case 1:
        query = "select distinct(zd.id_zdarzenie) as \"ID ZDARZENIA\",\
                prz.id_przewinienie as \"ID PRZEWINIENIE\", \
                zd.nazwa as \"OPIS ZDARZENIA\", prz.data_przewinienia as \"DATA PRZESTĘPSTWA\", prz.rodzaj_przewinienia as \"RODZAJ PRZESTĘPSTWA\",\
                d.rodzaj as \"RODZAJ DOWODU\", d.opis as \"OPIS DOWODU\"\
                from db.\"zdarzenie\" zd , db.\"przewinienie\" prz , db.\"dowod\" d ,db.\"uczestnik\" ucz\
                where zd.id_zdarzenie = prz.id_zdarzenie \
                and zd.id_zdarzenie= d.id_zdarzenie\
                and ucz.id_przewinienie = prz.id_przewinienie\
                and id_osoba is NULL;";
        break;
        case 2:
        query = "Select os.id_osoba as \"ID OSOBA\",\
                os.imie as \"IMIE\",\
                os.nazwisko as \"NAZWISKO\", \
                count(ucz.id_uczestnik) as \"ILOŚĆ UCZESTNICTWA W PRZESTĘPSTWACH\",\
                 count(k.id_kara) as \"ILOŚĆ DOSTANYCH KAR\"\
                 from db.\"osoba\" os \
                 left join db.\"uczestnik\" ucz on os.id_osoba=ucz.id_osoba \
                 left join db.\"przewinienie\" przew on przew.id_przewinienie=ucz.id_przewinienie\
                 left join db.\"sad\" s on s.id_przestepstwo = przew.id_przewinienie\
                 left join db.\"kara\" k on k.id_sad = s.id_sad\
                 where ucz.rodzaj_wmieszania='Przestępca'\
                 and s.data_rozprawy= (select max(data_rozprawy)        \
                       from db.\"sad\" sad\
                       where sad.id_przestepstwo=s.id_przestepstwo)\
         GROUP BY os.id_osoba;";
        break;
        case 3:
        query = "Select distinct(o.id_osoba),\
                o.imie as \"IMIE\", \
                o.nazwisko as \"NAZWISKO\", \
                w.nazwa as \"NAZWA WIEZIENIA\",\
                koniec_kary as \"DATA PLANOWANEGO WYJŚCIA Z WIĘZIENIA\"\
        from db.\"osoba\" o , db.\"uczestnik\" ucz, db.\"przewinienie\" przew, db.\"wiezienie\" w, db.\"kara\" k, db.\"sad\" s\
        Where o.id_osoba=ucz.id_osoba\
        and ucz.rodzaj_wmieszania='Przestępca'\
        and przew.id_przewinienie=ucz.id_przewinienie\
        and s.id_przestepstwo=przew.id_przewinienie\
        and k.id_sad=s.id_sad\
        and w.id_wiezienie= k.id_wiezienie\
        and s.data_rozprawy= (select max(data_rozprawy)\
        from db.\"sad\" sa\
       where sa.id_przestepstwo=s.id_przestepstwo) ;";
        break;
        case 4:
        query = "Select 	distinct (o.id_osoba) as \"ID OSOBY\",\
                o.imie as \"IMIE\", \
                o.nazwisko as \"NAZWISKO\", \
                ucz.rodzaj_wmieszania as \"Rodzaj uczestnictwa w zdarzeniu\", \
                k.rodzaj_kary as \"RODZAJ KARY\",\
                k.opis as \"OPIS KARY\",\
                s.id_sad as \"ID SĄDU\", \
                s.data_rozprawy as \"DATA ROZPRAWY\"\
        from db.\"osoba\" o , db.\"uczestnik\" ucz, db.\"przewinienie\" przew, db.\"wiezienie\" w, db.\"kara\" k, db.\"sad\" s\
        Where o.id_osoba=ucz.id_osoba\
        and ucz.rodzaj_wmieszania='Przestępca'\
        and przew.id_przewinienie=ucz.id_przewinienie\
        and s.id_przestepstwo=przew.id_przewinienie\
        and k.id_sad=s.id_sad\
        and k.rodzaj_kary != 'Więzienie'\
        and s.data_rozprawy= (select max(data_rozprawy)\
                      from db.\"sad\" sa\
                      where sa.id_przestepstwo=s.id_przestepstwo);";
        break;
        case 5:
        query = "Select przew.id_przewinienie as \"ID PRZESTĘPSTWA\",\
                przew.rodzaj_przewinienia as \"RODZAJ PRZESTĘPSTWA\",\
                s.decyzja as \"DECYZJA SĄDU\",\
                s.instancja as \"INSTANCJA SĄDU\",\
                k.rodzaj_kary as \"RODZAJ KARY\"\
            From db.\"przewinienie\" as przew, db.\"sad\" as s , db.\"uczestnik\" as ucz , db.\"kara\" k\
            where przew.id_przewinienie=s.id_przestepstwo\
            and przew.id_przewinienie = ucz.id_przewinienie\
            and k.id_sad = s.id_sad\
            and ucz.rodzaj_wmieszania = 'Przestępca'\
            and s.data_rozprawy= (select max(data_rozprawy)\
                          from db.\"sad\" sa\
                          where sa.id_przestepstwo=s.id_przestepstwo);";
        break;
        case 6:
        query = "Select o.id_osoba as \"ID OSOBA\",\
                o.imie as \"IMIE\", \
                o.nazwisko as \"NAZWISKO\", \
                o.data_urodzenia as \"DATA URODZENIA\", przew.id_przewinienie AS \"ID PRZEWINIENIA\", \
                przew.rodzaj_przewinienia AS \"RODZAJ PRZEWINIENIA\",\
                s.instancja AS \"INSTANCJA SĄDU\", s.decyzja as \"DECYZJA SĄÐU\", \
                k.rodzaj_kary as \"RODZAJ KARY\"\
            from db.\"osoba\" o \
            left join db.\"uczestnik\" ucz on o.id_osoba=ucz.id_osoba \
            left join db.\"przewinienie\" przew on przew.id_przewinienie=ucz.id_przewinienie\
            left join db.\"sad\" s on s.id_przestepstwo = przew.id_przewinienie\
            left join db.\"kara\" k on k.id_sad = s.id_sad\
            where ucz.rodzaj_wmieszania='Przestępca';";
        break;
        case 7:
        query = "select zd.id_zdarzenie as \"ID ZDARZENIE\", zd.policjant as \"PROWADZĄCY SPRAWĘ POLICJANT\", \
                zd.nazwa as \"NAZWA SPRAWY\", zd.data_rozpoczecia as \"DATA ROZPOCZĘCIA ŚLEDZTWA\",\
                    count(przew.id_przewinienie) as \"ILOŚĆ PRZESTĘPSTW\",\
                    count(distinct(ucz.id_osoba)) as \"ILOŚĆ ZNANYCH PRZESTĘPCÓW\"\
            from db.\"zdarzenie\" zd , db.\"przewinienie\" przew , db.\"uczestnik\" ucz\
            where zd.id_zdarzenie = przew.id_zdarzenie\
            and ucz.id_przewinienie = przew.id_przewinienie\
            and zd.data_zakonczenia is null\
            and ucz.rodzaj_wmieszania = 'Przestępca'\
            group by zd.id_zdarzenie;";
        break;
        case 8:
        query = "select zd.id_zdarzenie \"ID SPRAWY\", zd.nazwa as \"NAZWA SPRAWY\" , s.id_swiadek as \"ID ŚWIADKA\", \
                o.imie as \"IMIE ŚWIADKA\" , o.nazwisko as \"NAZWISKO ŚWIADKA\",\
                s.zeznania as \"ZEZNANIA\"\
        from db.\"zdarzenie\" zd ,db.\"swiadek\" s,db.\"osoba\" o\
        where  s.id_zdarzenie = zd.id_zdarzenie\
        and o.id_osoba = s.id_osoba;";
        break;
        case 9:
        query = "select  zd.id_zdarzenie \"ID SPRAWY\", zd.nazwa as \"NAZWA ZDARZENIA\" , przew.id_przewinienie as \"ID PRZEWINIENIE\",\
                s.sedzia  \"SĘDZIA PROWADZĄCY SPRAWĘ\", s.instancja as \"INSTANCJA SĄDU\" ,\
                    data_rozpoczecia as \"DATA ROZPOCZĘCIA SPRAWY\" , data_rozprawy as \"DATA ROZPRAWY\" \
            from db.\"zdarzenie\" zd\
            left join db.\"przewinienie\" przew on zd.id_zdarzenie = przew.id_zdarzenie\
            left join db.\"sad\" s on  s.id_przestepstwo = przew.id_przewinienie\
            and s.data_rozprawy= (select max(data_rozprawy)\
                          from db.\"sad\" sa\
                          where sa.id_przestepstwo=s.id_przestepstwo);";
        break;

        default:
            query="";
        break;
    }

    showTable(query);
}


void MainWindow::on_actionZaloguj_Si_triggered()
{
    m_login->show();
}


void MainWindow::on_actionWyloguj_Si_triggered()
{
    m_db->disconnect();
    ui->comboBox_table->setEnabled(false);
    ui->pushButton_input->setEnabled(false);
    ui->pushButton_delete->setEnabled(false);
    ui->actionZaloguj_Si->setEnabled(true);
    ui->actionWyloguj_Si->setEnabled(false);
    ui->pushButton->setEnabled(false);
    ui->pushButton_2->setEnabled(false);
    ui->comboBox_specialQ->setEnabled(false);
    ui->spinBox->setEnabled(false);
    ui->lineEdit->setEnabled(false);
    ui->lineEdit_2->setEnabled(false);
    m_db->setDBName(QString::fromStdString  (""));
    m_db->setUserName(QString::fromStdString(""));
    m_db->setPasswd(QString::fromStdString  (""));
    m_db->setHostAddress(QString::fromStdString(""));
    m_db->setPort(QString::fromStdString    (""));
}


void MainWindow::on_pushButton_clicked()
{
    std::string query = "SELECT * FROM db.getCountCrime("+std::to_string(ui->spinBox->value())+")";
    showTable(QString::fromStdString(query));
}


void MainWindow::on_pushButton_2_clicked()
{
    QString query = "SELECT * FROM db.getATrialOfACriminal('"+ui->lineEdit->text()+"','"+ui->lineEdit_2->text()+"')";
    showTable(query);
}

