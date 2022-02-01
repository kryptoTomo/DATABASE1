#ifndef DATABASE_H
#define DATABASE_H

#include <iostream>
#include <string>
#include <pqxx/pqxx>
#include <memory>
#include <QString>
#include <QWidget>
#include <QObject>


/**
 * @brief Klasa Database 
 * Klasa na potrzeby połączenia z bazą danych PostgreSQL
 */

class MainWindow;

class Database : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief Konstruktor domyślny
     * 
     * @param dbName 
     * @param user 
     * @param pass 
     * @param hostaddr 
     * @param port 
     */
    Database(QString dbName = "", QString user = "", QString pass = "", QString hostaddr = "", QString port = "");
    /**
     * @brief Destruktor
     */
    virtual ~Database();
//    ~Database();

    /**
     * @brief Metoda zakłada połączenie z bazą danych na podstawie wprowadzonych danych
     */
    void connect();
    /**
     * @brief Metoda wysyła zapytanie do bazy danych.
     * 
     * @param request Zapytanie
     * @param saveMode True, jeśli zapytanie jest typu INSERT
     * @return pqxx::result Odpowiedź bazy danych
     */
    pqxx::result sendQuery(QString request, bool saveMode = false);

    /**
     * @brief deleteData Usuwa wiersz z tabeli
     * @param request Polecenie sql do usuwania rejestrów
     */
    pqxx::result deleteData(QString request);

    /**
     * Settery 
     */
    void setDBName      (QString arg);
    void setUserName    (QString arg);
    void setPasswd      (QString arg);
    void setHostAddress (QString arg);
    void setPort        (QString arg);
    void setSelectedTab (QString arg);

    /**
     * @brief Zwraca nazwę aktualnie wybranej tabeli
     * 
     * @return QString 
     */
    QString getSelectedTab() const;
    /**
     * @brief Czy połączenie z bazą jest aktywne
     * 
     * @return true 
     * @return false 
     */
    bool isConnected() const;


signals:
    /** 
     * @brief Sygnał wysyła wiadomość do konsoli w oknie
     */
    void emit_log(const QString text, bool red = false) const;

private:

    // Dane logowania
    QString m_dbName, m_user, m_password, m_hostAddres, m_port;
    bool m_DBisConnected;
    std::unique_ptr<pqxx::connection> m_connection;
    QString m_selectedTable;

};


#endif // DATABASE_H
