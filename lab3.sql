CREATE DATABASE QLHH
ON
PRIMARY (
    NAME = QLHH_Data,
    FILENAME = 'D:\SQL-lab2_Data.mdf', -- Đường dẫn tới file, bạn có thể thay đổi theo môi trường của mình
    SIZE = 50MB,                           -- Kích thước ban đầu của file dữ liệu
    MAXSIZE = 200MB,                        -- Giới hạn kích thước tối đa của file dữ liệu
    FILEGROWTH = 10MB                       -- Mỗi lần tăng 10MB
)
LOG ON
(
    NAME = QLHH_Log,
    FILENAME = 'D:\SQL-lab2_Log.ldf',   -- Đường dẫn tới file log, có thể thay đổi theo môi trường của mình
    SIZE = 10MB,                            -- Kích thước ban đầu của file log
    FILEGROWTH = 5MB                        -- Mỗi lần tăng 5MB, không giới hạn kích thước tối đa
);
