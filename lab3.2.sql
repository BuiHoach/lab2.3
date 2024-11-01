CREATE DATABASE  QLBH;
GO
USE QLBH;
GO

-- Tạo bảng VATTU
CREATE TABLE VATTU (
    MaVTu CHAR(4) NOT NULL PRIMARY KEY,               -- Mã vật tư, khóa chính, không được để trống
    TenVTu VARCHAR(100) NOT NULL UNIQUE,              -- Tên vật tư, không trùng, không được để trống
    DvTinh VARCHAR(10) NULL DEFAULT '',               -- Đơn vị tính, cho phép NULL, mặc định là ""
    PhanTram REAL CHECK (PhanTram >= 0 AND PhanTram <= 100)  -- Tỷ lệ phần trăm, giá trị từ 0 đến 100
);
GO

-- Tạo bảng NHACC
CREATE TABLE NHACC (
    MaNhaCc CHAR(3) NOT NULL PRIMARY KEY,             -- Mã nhà cung cấp, khóa chính, không được để trống
    TenNhaCc VARCHAR(100) NOT NULL,                   -- Tên nhà cung cấp, không được để trống
    DiaChi VARCHAR(200) NOT NULL,                     -- Địa chỉ, không được để trống
    DienThoai VARCHAR(20) NULL DEFAULT 'Chưa có'      -- Điện thoại, cho phép NULL, mặc định là "Chưa có"
);
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
