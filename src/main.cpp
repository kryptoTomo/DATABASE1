#include "mainwindow.h"
#include "database.h"
#include <iostream>
#include <QApplication>

int main(int argc, char *argv[])
{
    std::cout << "Starting DB app...\n";
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
