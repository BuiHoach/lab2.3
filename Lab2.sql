-- Tạo cơ sở dữ liệu có tên Lab02
CREATE DATABASE Lab02;
GO

-- Gọi cơ sở dữ liệu ra sử dụng
USE Lab02;
GO

-- Khai báo biến Name, gán giá trị và in ra
DECLARE @Name NVARCHAR(50) = N'Nguyen Van A';
PRINT 'Name: ' + @Name;
GO

-- Khai báo biến Age, gán giá trị và in ra
DECLARE @Age INT = 25;
PRINT 'Age: ' + CAST(@Age AS NVARCHAR);
GO

-- Tạo bảng Employee với các thông tin như yêu cầu
CREATE TABLE Employee (
    ID INT PRIMARY KEY,
    FullName NVARCHAR(35),
    Gender BIT,
    BirthDay DATETIME,
    Address NVARCHAR(MAX),
    Email VARCHAR(50),
    Salary FLOAT
);
GO

-- Thêm cột phone vào bảng Employee
ALTER TABLE Employee
ADD Phone VARCHAR(20);
GO

-- Nhập vào tối thiểu 5 bản ghi
INSERT INTO Employee (ID, FullName, Gender, BirthDay, Address, Email, Salary, Phone)
VALUES 
(1, N'Tran Thi B', 0, '1990-05-15', N'123 Le Loi, HCM', 'tranthiB@example.com', 3000000, '0123456789'),
(2, N'Nguyen Van C', 1, '1985-12-30', N'456 Hai Ba Trung, HN', 'nguyenvanc@example.com', 2500000, '0987654321'),
(3, N'Pham Thi D', 0, '1992-07-20', N'789 Tran Hung Dao, DN', 'phamthid@example.com', 1500000, '0901234567'),
(4, N'Le Van E', 1, '1988-10-10', N'321 Nguyen Trai, BD', 'levane@example.com', 4000000, '0912345678'),
(5, N'Hoang Thi F', 0, '1995-03-05', N'654 Le Lai, HCM', 'hoangthif@example.com', 2200000, '0923456789');
GO

-- Đưa ra tất cả các nhân viên trong công ty
SELECT * FROM Employee;
GO

-- Đưa ra các nhân viên có lương > 2000000
SELECT * FROM Employee
WHERE Salary > 2000000;
GO

-- Đưa ra các nhân viên có sinh nhật trong tháng này
SELECT * FROM Employee
WHERE MONTH(BirthDay) = MONTH(GETDATE());
GO

-- Đưa ra danh sách nhân viên hiển thị kèm thêm cột tuổi và cột BirthDay hiển thị dạng dd/mm/yyyy
SELECT 
    ID,
    FullName,
    Gender,
    CONVERT(VARCHAR(10), BirthDay, 103) AS BirthDay,  -- Định dạng dd/mm/yyyy
    Address,
    Email,
    Salary,
    Phone,
    DATEDIFF(YEAR, BirthDay, GETDATE()) AS Age        -- Tính tuổi
FROM Employee;
GO

-- Đưa ra những nhân viên có địa chỉ ở Hà Nội
SELECT * FROM Employee
WHERE Address LIKE N'%Hà Nội%';
GO

-- Sửa tên nhân viên có mã là "NV01" thành tên "John"
UPDATE Employee
SET FullName = N'John'
WHERE ID = 1;  -- Mã NV01 tương ứng với ID là 1
GO

-- Xóa những nhân viên có tuổi > 50
DELETE FROM Employee
WHERE DATEDIFF(YEAR, BirthDay, GETDATE()) > 50;
GO

-- Copy những nhân viên có tuổi > 50 sang một bảng mới
-- Tạo bảng mới để lưu trữ các nhân viên có tuổi > 50
CREATE TABLE Employee_Over50 AS
SELECT *
FROM Employee
WHERE DATEDIFF(YEAR, BirthDay, GETDATE()) > 50;
GO

-- Đếm số nhân viên
SELECT COUNT(*) AS EmployeeCount FROM Employee;
GO
