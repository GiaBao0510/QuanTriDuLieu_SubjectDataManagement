-- --------------------------------------------------------
-- Máy chủ:                      127.0.0.1
-- Server version:               10.4.24-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Phiên bản:           12.0.0.6468
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for qldiem
CREATE DATABASE IF NOT EXISTS `qldiem` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `qldiem`;

-- Dumping structure for table qldiem.hocphan
CREATE TABLE IF NOT EXISTS `hocphan` (
  `maHP` char(6) NOT NULL,
  `tenHP` varchar(50) NOT NULL,
  `soTinChi` int(11) DEFAULT NULL,
  `soTietLT` int(11) DEFAULT NULL,
  `soTietTH` int(11) DEFAULT NULL,
  PRIMARY KEY (`maHP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table qldiem.hocphan: ~9 rows (approximately)
INSERT INTO `hocphan` (`maHP`, `tenHP`, `soTinChi`, `soTietLT`, `soTietTH`) VALUES
	('CT101', 'Lập Trình Căn Bản', 4, 30, 60),
	('CT176', 'Lập Trình Hướng đối tượng', 3, 30, 30),
	('CT237', 'Nguyên lý Hệ Điều Hành', 3, 30, 30),
	('SP102', 'Đại số tuyến tính', 4, 60, 0),
	('TN001', 'Vi tích phân A1', 3, 45, 0),
	('TN021', 'Hóa học đại cương', 3, 60, 0),
	('TN101', 'Xác suất thống kê', 3, 45, 0),
	('TN172', 'Toán rời rạc', 4, 60, 0),
	('XH023', 'Anh Văn Căn Bản 1', 4, 60, 0);

-- Dumping structure for table qldiem.ketqua
CREATE TABLE IF NOT EXISTS `ketqua` (
  `mssv` char(8) NOT NULL,
  `maHP` char(6) NOT NULL,
  `diem` float DEFAULT NULL,
  KEY `mssv` (`mssv`),
  KEY `maHP` (`maHP`),
  CONSTRAINT `ketqua_ibfk_1` FOREIGN KEY (`mssv`) REFERENCES `sinhvien` (`mssv`),
  CONSTRAINT `ketqua_ibfk_2` FOREIGN KEY (`maHP`) REFERENCES `hocphan` (`maHP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table qldiem.ketqua: ~20 rows (approximately)
INSERT INTO `ketqua` (`mssv`, `maHP`, `diem`) VALUES
	('B1234567', 'CT101', 4),
	('B1234568', 'CT176', 8),
	('B1234569', 'CT237', 9),
	('B1334569', 'SP102', 2),
	('B1345678', 'CT101', 6),
	('B1345679', 'CT176', 5),
	('B1456789', 'TN172', 10),
	('B1459230', 'TN172', 7),
	('B1456789', 'XH023', 6),
	('B1459230', 'XH023', 8),
	('B1234567', 'CT176', 1),
	('B1234568', 'CT101', 9),
	('B1234569', 'CT101', 8),
	('B1334569', 'CT101', 4),
	('B1345678', 'TN001', 6),
	('B1345679', 'CT101', 2),
	('B1456789', 'CT101', 7),
	('B1456790', 'TN101', 6),
	('B1345680', 'TN101', 7),
	('B1345680', 'XH023', 7);

-- Dumping structure for table qldiem.khoa
CREATE TABLE IF NOT EXISTS `khoa` (
  `maKhoa` char(8) NOT NULL,
  `tenKhoa` varchar(50) NOT NULL,
  PRIMARY KEY (`maKhoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table qldiem.khoa: ~6 rows (approximately)
INSERT INTO `khoa` (`maKhoa`, `tenKhoa`) VALUES
	('CNTT&TT', 'Công nghệ thông tin & Truyền thông'),
	('KT', 'Khoa kinh tế'),
	('NNG', 'Khoa Ngoại ngữ'),
	('SP', 'Khoa Sư Phạm'),
	('TN', 'Khoa Khoa Học Tự nhiên'),
	('TS', 'Khoa Thủy Sản');

-- Dumping structure for table qldiem.sinhvien
CREATE TABLE IF NOT EXISTS `sinhvien` (
  `mssv` char(8) NOT NULL,
  `hoten` varchar(45) NOT NULL,
  `gioiTinh` char(1) NOT NULL,
  `ngaySinh` date NOT NULL,
  `noiSinh` varchar(40) NOT NULL,
  `DiaChi` varchar(100) NOT NULL,
  `maKhoa` varchar(8) NOT NULL,
  PRIMARY KEY (`mssv`),
  KEY `maKhoa` (`maKhoa`),
  CONSTRAINT `sinhvien_ibfk_1` FOREIGN KEY (`maKhoa`) REFERENCES `khoa` (`maKhoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table qldiem.sinhvien: ~10 rows (approximately)
INSERT INTO `sinhvien` (`mssv`, `hoten`, `gioiTinh`, `ngaySinh`, `noiSinh`, `DiaChi`, `maKhoa`) VALUES
	('B1234567', 'Nguyễn Thành Hải', 'M', '2000-12-02', 'Bạc Liêu', 'Phòng 01, KTX Khu B,', 'CNTT&TT'),
	('B1234568', 'Trần Thanh Mai', 'M', '2001-01-20', 'Cần Thơ', '232, Nguyễn Văn Khéo,Q.Ninh Kiều ,TPCT', 'CNTT&TT'),
	('B1234569', 'Trần Thu Thủy', 'F', '2001-07-01', 'Cần Thơ', '02, Đại lộ Hòa Bình, Q.Ninh Kiều , TPCT', 'CNTT&TT'),
	('B1334569', 'Nguyễn Thị Trúc Mã', 'F', '2002-05-25', 'Sóc Trăng', '343, Đường 30/4, Q/Ninh Kiều, TPCT', 'SP'),
	('B1345678', 'Trần Hồng Trúc', 'F', '2002-03-02', 'Cần Thơ', '123, Trần Hưng Đạo, Q.Ninh Kiều , TPCT', 'CNTT&TT'),
	('B1345679', 'Bùi Hoàng Yến', 'F', '2001-11-05', 'Vĩnh Long', 'Phòng 201, KTX Khu A,TPCT', 'CNTT&TT'),
	('B1345680', 'Trần Minh Tâm', 'M', '2001-02-04', 'Cà Mau', '07, Đại lộ Hòa Bình, Q.Ninh Kiều,TPCT', 'KT'),
	('B1456789', 'Nguyễn Hồng Thắm', 'F', '2003-05-09', 'An Giang', '133, Nguyễn Văn Cừ, Q.Ninh Kiều,TPCT', 'NNG'),
	('B1456790', 'Lê Khải Hoàng', 'M', '2002-07-03', 'Kiên Giang', '03, Trần Hoàng Na, Q.Ninh Kiều,TPCT', 'TS'),
	('B1459230', 'Lê Văn Khang', 'M', '2002-06-02', 'Đồng Tháp', '312, Nguyễn Văn Linh, Q.Ninh Kiều,TPCT', 'TN');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
