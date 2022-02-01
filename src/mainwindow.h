#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QScrollBar>
#include "database.h"
#include "login.h"
#include <QRegularExpression>
#include <QMessageBox>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

/**
 * @brief Klasa reprezentująca główne okno aplikacji
 * 
 */

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    /**
     * @brief Konstruktor domyślny
     * 
     * @param parent 
     */
    MainWindow(QWidget *parent = nullptr);
    /**
     * @brief Destruktor
     * 
     */
    ~MainWindow();

    /**
     * @brief Metoda tworzy tabelę na podstawie odpowiedzi bazy danych
     * 
     * @param query Zapytanie do bazy danych
     */
    void showTable(QString query);

public slots:
    /**
     * @brief Metoda obiera wiadomość i wpisuje ją do konsoli okna głównego aplikacji
     * 
     * @param text 
     * @param red 
     */
    void catch_log(const QString text, bool red = false);

private slots:
/**
 * Metody obsługują zdarzenia wynikające z obsługi okna głównego
 */
    void onLoginOKClicked();
    void onAboutClicked() const;
    void onExitClicked();
    void on_pushButton_submit_clicked();
    void on_comboBox_table_currentIndexChanged(int index);
    void on_pushButton_input_clicked();
    void on_pushButton_save_clicked();
    void on_comboBox_tablestretch_activated(int index);
    void on_pushButton_delete_clicked();
    void on_pushButton_clearConsole_clicked();

    void on_comboBox_specialQ_currentIndexChanged(int index);

    void on_actionZaloguj_Si_triggered();

    void on_actionWyloguj_Si_triggered();

    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

private:
    /**
     * @brief Wskaźnik na elementy graficzne okna głównego
     * 
     */
    Ui::MainWindow *ui;
//    std::unique_ptr<Database> m_db;
    Database * m_db;
    login * m_login;
    unsigned m_logCounter;
    bool m_isAppendingData;

};
#endif // MAINWINDOW_H
