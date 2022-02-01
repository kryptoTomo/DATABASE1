#ifndef LOGIN_H
#define LOGIN_H

#include <QDialog>
#include <string>

namespace Ui {
class login;
}

class login : public QDialog
{
    Q_OBJECT

public:
    explicit login(QWidget *parent = nullptr);
    ~login();

    std::string getDBName() const;
    std::string getUserName() const;
    std::string getPasswd() const;
    std::string getHostAddress() const;
    std::string getPort() const;


private slots:
    void on_buttonBox_accepted();

signals:
    void emit_login_data();

private:
    Ui::login *ui;
};

#endif // LOGIN_H
