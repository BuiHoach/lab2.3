CREATE DATABASE  QLBH;
GO
USE QLBH;
GO

-- Tạo bảng VATTU
CREATE TABLE VATTU (
    MaVTu CHAR(4) NOT NULL PRIMARY KEY,               -- Mã vật tư, khóa chính, không được để trống
    TenVTu VARCHAR(100) NOT NULL UNIQUE,              -- Tên vật tư, không trùng, không được để trống
    DvTinh VARCHAR(10) NULL DEFAULT '',                -- Đơn vị tính, cho phép NULL, mặc định là ""
    PhanTram REAL CHECK (PhanTram >= 0 AND PhanTram <= 100)  -- Tỷ lệ phần trăm, giá trị từ 0 đến 100
);
GO

-- Tạo bảng NHACC
CREATE TABLE NHACC (
    MaNhaCc CHAR(10) NOT NULL PRIMARY KEY,             -- Mã nhà cung cấp, khóa chính, không được để trống
    TenNhaCc VARCHAR(100) NOT NULL,                    -- Tên nhà cung cấp, không được để trống
    DiaChi VARCHAR(200) NOT NULL,                      -- Địa chỉ, không được để trống
    DienThoai VARCHAR(20) NULL DEFAULT 'Chưa có'      -- Điện thoại, cho phép NULL, mặc định là "Chưa có"
);
GO
GO
CREATE TABLE DONDH (
    SoDh CHAR(4) NOT NULL PRIMARY KEY,           -- Số đơn đặt hàng, khóa chính, không được để trống
    NgayDh DATETIME DEFAULT GETDATE(),           -- Ngày đặt hàng, mặc định là ngày hiện tại
    MaNhaCc CHAR(3) NOT NULL,                    -- Mã nhà cung cấp, không được để trống
    FOREIGN KEY (MaNhaCc) REFERENCES NHACC(MaNhaCc) -- Khóa ngoại tham chiếu đến MaNhaCc trong bảng NHACC
);
GO

-- Tạo bảng CTDONDH
CREATE TABLE CTDONDH (
    SoDh CHAR(4) NOT NULL,                       -- Số đơn đặt hàng, không được để trống, khóa ngoại tham chiếu DONDH
    MaVTu CHAR(4) NOT NULL,                      -- Mã vật tư, không được để trống, khóa ngoại tham chiếu VATTU
    SoLuong INT CHECK (SoLuong > 0),             -- Số lượng, có ràng buộc lớn hơn 0
    DonGia DECIMAL(18, 2) CHECK (DonGia >= 0),   -- Đơn giá, có ràng buộc không âm
    PRIMARY KEY (SoDh, MaVTu),                   -- Khóa chính kết hợp từ SoDh và MaVTu
    FOREIGN KEY (SoDh) REFERENCES DONDH(SoDh),   -- Khóa ngoại tham chiếu đến SoDh trong bảng DONDH
    FOREIGN KEY (MaVTu) REFERENCES VATTU(MaVTu)  -- Khóa ngoại tham chiếu đến MaVTu trong bảng VATTU
);
GO
CREATE TABLE PNHAP (
    SoPn CHAR(4) NOT NULL PRIMARY KEY,              -- Số phiếu nhập hàng, khóa chính, không được để trống
    NgayNhap DATETIME DEFAULT GETDATE(),            -- Ngày nhập hàng, mặc định là ngày hiện tại
    SoDh CHAR(4) NOT NULL,                          -- Số đơn đặt hàng, không được để trống
    FOREIGN KEY (SoDh) REFERENCES DONDH(SoDh)       -- Khóa ngoại tham chiếu đến SoDh trong bảng DONDH
);
GO

-- Tạo bảng CTPNHAP
CREATE TABLE CTPNHAP (
    SoPn CHAR(4) NOT NULL,                          -- Số phiếu nhập hàng, không được để trống, khóa ngoại tham chiếu PNHAP
    MaVTu CHAR(4) NOT NULL,                         -- Mã vật tư, không được để trống, khóa ngoại tham chiếu VATTU
    SINhap INT NOT NULL CHECK (SINhap > 0),         -- Số lượng nhập hàng, phải lớn hơn 0
    DgNhap MONEY NOT NULL CHECK (DgNhap > 0),       -- Đơn giá nhập hàng, phải lớn hơn 0
    PRIMARY KEY (SoPn, MaVTu),                      -- Khóa chính kết hợp từ SoPn và MaVTu
    FOREIGN KEY (SoPn) REFERENCES PNHAP(SoPn),      -- Khóa ngoại tham chiếu đến SoPn trong bảng PNHAP
    FOREIGN KEY (MaVTu) REFERENCES VATTU(MaVTu)     -- Khóa ngoại tham chiếu đến MaVTu trong bảng VATTU
);
GO
-- Tạo bảng PXUAT
CREATE TABLE PXUAT (
    SoPx CHAR(4) NOT NULL PRIMARY KEY,               -- Số phiếu xuất, khóa chính, không được để trống
    NgayXuat DATETIME DEFAULT GETDATE(),             -- Ngày xuất hàng, mặc định là ngày hiện tại
    TenKh VARCHAR(100) NOT NULL                      -- Tên khách hàng, không được để trống
);
GO

-- Tạo bảng CTPXUAT
CREATE TABLE CTPXUAT (
    SoPx CHAR(4) NOT NULL,                           -- Số phiếu xuất, không được để trống, khóa ngoại tham chiếu PXUAT
    MaVTu CHAR(4) NOT NULL,                          -- Mã vật tư, không được để trống, khóa ngoại tham chiếu VATTU
    SIXuat INT NOT NULL CHECK (SIXuat > 0),          -- Số lượng xuất hàng, phải lớn hơn 0
    DgXuat MONEY NOT NULL CHECK (DgXuat > 0),        -- Đơn giá xuất hàng, phải lớn hơn 0
    PRIMARY KEY (SoPx, MaVTu),                       -- Khóa chính kết hợp từ SoPx và MaVTu
    FOREIGN KEY (SoPx) REFERENCES PXUAT(SoPx),       -- Khóa ngoại tham chiếu đến SoPx trong bảng PXUAT
    FOREIGN KEY (MaVTu) REFERENCES VATTU(MaVTu)      -- Khóa ngoại tham chiếu đến MaVTu trong bảng VATTU
);
GO
-- Tạo bảng TONKHO
CREATE TABLE TONKHO (
    NamThang CHAR(6) NOT NULL,                      -- Năm tháng, không được để trống
    MaVTu CHAR(4) NOT NULL,                         -- Mã vật tư, không được để trống
    SLDau INT NOT NULL CHECK (SLDau > 0),           -- Số lượng tồn đầu kỳ, phải lớn hơn 0
    TongSLN INT NOT NULL CHECK (TongSLN > 0),       -- Tổng số lượng nhập trong kỳ, phải lớn hơn 0
    TongSLX INT NOT NULL CHECK (TongSLX > 0),       -- Tổng số lượng xuất trong kỳ, phải lớn hơn 0
    SLCuoi INT NOT NULL,                             -- Số lượng tồn cuối kỳ
    PRIMARY KEY (NamThang, MaVTu),                  -- Khóa chính kết hợp từ NamThang và MaVTu
    FOREIGN KEY (MaVTu) REFERENCES VATTU(MaVTu)    -- Khóa ngoại tham chiếu đến MaVTu trong bảng VATTU
);
GO
-- Thêm dữ liệu vào bảng NHACC
INSERT INTO NHACC (MaNhaCc, TenNhaCc, DiaChi, DienThoai) VALUES
('C01', 'Lê Minh Thành', '54, Kim Mã, Cầu Giấy, Hà Nội', '8781024'),
('C02', 'Trần Quang Anh', '145, Hùng Vương, Hải Dương', '7698154'),
('C03', 'Bùi Hồng Phương', '154/85, Lê Chân, Hải Phòng', '9600125'),
('C04', 'Vũ Nhật Thắng', '198/40 Hương Lộ 14, QTB HCM', '8757757'),
('C05', 'Nguyễn Thị Thúy', '178 Nguyễn Văn Luông, Đà Lạt', '7964251'),
('C07', 'Cao Minh Trung', '125 Lê Quang Sung, Nha Trang', 'Chưa có');
GO
INSERT INTO VATTU (MaVTu, TenVTu, DvTinh, PhanTram) VALUES
('DD01', 'Đầu DVD Hitachi 1 đĩa', 'BỘ', 40),
('DD02', 'Đầu DVD Hitachi 3 đĩa', 'BỘ', 40),
('TL15', 'Tủ lạnh Sanyo 150 lit', 'Cái', 25),
('TL90', 'Tủ lạnh Sanyo 90 lit', 'Cái', 20),
('TV14', 'Tivi Sony 14 inches', 'Cái', 15),
('TV21', 'Tivi Sony 21 inches', 'Cái', 10),
('TV29', 'Tivi Sony 29 inches', 'Cái', 10),
('VD01', 'Đầu VCD Sony 1 đĩa', 'BỘ', 30),
('VD02', 'Đầu VCD Sony 3 đĩa', 'BỘ', 30);
GO

-- Thêm dữ liệu vào bảng DONDH
INSERT INTO DONDH (SoDh, NgayDh, MaNhaCc) VALUES
('D001', '2012-01-15', 'C03'),  -- Ngày 15 tháng 01 năm 2012, mã nhà cung cấp C03
('D002', '2012-01-30', 'C01'),  -- Ngày 30 tháng 01 năm 2012, mã nhà cung cấp C01
('D003', '2012-02-10', 'C02'),  -- Ngày 10 tháng 02 năm 2012, mã nhà cung cấp C02
('D004', '2012-02-17', 'C02'),  -- Ngày 17 tháng 02 năm 2012, mã nhà cung cấp C02
('D005', '2012-03-01', 'C05'),  -- Ngày 01 tháng 03 năm 2012, mã nhà cung cấp C05
('D006', '2012-03-12', 'C05');  -- Ngày 12 tháng 03 năm 2012, mã nhà cung cấp C05
GO
