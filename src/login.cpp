#include "login.h"
#include "ui_login.h"

login::login(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::login)
{
    ui->setupUi(this);

    ui->l_dbName->insert("u9madej");
    ui->l_username->insert("u9madej");
    ui->l_passwd->insert("9madej");
    ui->l_hostAddr->insert("127.0.0.1");
    ui->l_port->insert("5432");

}

login::~login()
{
    delete ui;
}


std::string login::getDBName()          const { return ui->l_dbName->text().toStdString();  }
std::string login::getUserName()        const { return ui->l_username->text().toStdString();}
std::string login::getPasswd()          const { return ui->l_passwd->text().toStdString();  }
std::string login::getHostAddress()     const { return ui->l_hostAddr->text().toStdString();}
std::string login::getPort()            const { return ui->l_port->text().toStdString();    }

void login::on_buttonBox_accepted()
{
    emit emit_login_data();
}

