#include "database.h"

Database::Database(QString dbName, QString user, QString pass, QString hostaddr, QString port)
:
    m_dbName(dbName)
    , m_user(user)
    , m_password(pass)
    , m_hostAddres(hostaddr)
    , m_port(port)
    , m_DBisConnected(false)
    , m_selectedTable("adres_czytelnika")
{
    emit emit_log("Starting DB app...");
}

Database::~Database() //{}
{
    if (m_DBisConnected)
        m_connection -> disconnect();
}

void Database::connect()
{
    QString return_value = "";
    if (!m_DBisConnected)
    {
        try
        {
            QString request = "dbname = " + m_dbName + " user = " + m_user + " password = " + m_password + " hostaddr = " + m_hostAddres + " port = " + m_port;

            m_connection = std::make_unique<pqxx::connection>(request.toStdString());


            m_DBisConnected = true;

            if (m_connection -> is_open()) {
                std::cout << "Opened database successfully: " << m_connection -> dbname() << std::endl;
                return_value += "Opened database successfully: ";
                return_value += m_connection -> dbname();
                return_value += "\n";
                emit emit_log(return_value);

            } else {
                std::cout << "Can't open database" << std::endl;
                emit emit_log("Can't open database.\n", true);
            }

        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            emit emit_log(e.what(), true);
        }
    }
}

pqxx::result Database::sendQuery(QString request, bool saveMode)
{
    pqxx::result temp;
    if (m_DBisConnected)
    {
        try
        {
            pqxx::work w {*m_connection};
            pqxx::result res { w.exec(request.toStdString()) };
            if (saveMode)
            {
                w.commit();
                emit emit_log("Data has been appended successfully\n");
            }

            return res;
        }
        catch (pqxx::sql_error const & e)
        {
            std::cerr << "SQL error: " << e.what() << std::endl;
            std::cerr << "SQL query: " << e.query() << std::endl;
            emit emit_log(QString::fromStdString(std::string("SQL error: ") + std::string(e.what()) + std::string("SQL query: ") + std::string(e.query()) + '\n'), true);
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            emit emit_log(QString::fromStdString(e.what()), true);
        }
    }
    else
    {
        std::cout << "Data base connection is down\n";
        emit emit_log("Data base connection is down\n", true);
    }

    return temp;
}

pqxx::result Database::deleteData(QString request)
{
    pqxx::result temp;
    if (m_DBisConnected)
    {
        try
        {
            pqxx::work w {*m_connection};

            temp = w.exec(request.toStdString());

            w.commit();
            emit emit_log("Data has been removed successfully\n");


        }
        catch (pqxx::sql_error const & e)
        {
            std::cerr << "SQL error: " << e.what() << std::endl;
            std::cerr << "SQL query: " << e.query() << std::endl;
            emit emit_log(QString::fromStdString(std::string("SQL error: ") + std::string(e.what()) + std::string("SQL query: ") + std::string(e.query()) + '\n'), true);
        }
        catch(const std::exception& e)
        {
            std::cerr << e.what() << '\n';
            emit emit_log(QString::fromStdString(e.what()) + "\n", true);
        }
    }
    else
    {
        std::cout << "Data base connection is down\n";
        emit emit_log("Data base connection is down\n", true);
    }
    return temp;
}


void Database::setDBName      (QString arg) { m_dbName = arg; }
void Database::setUserName    (QString arg) { m_user = arg; }
void Database::setPasswd      (QString arg) { m_password = arg; }
void Database::setHostAddress (QString arg) { m_hostAddres = arg; }
void Database::setPort        (QString arg) { m_port = arg; }
void Database::setSelectedTab (QString arg) { m_selectedTable = arg; }

QString Database::getSelectedTab() const    { return m_selectedTable; }
bool Database::isConnected() const          { return m_DBisConnected; }
