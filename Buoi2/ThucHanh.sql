-- 1. Thủ tục thêm sinh viên
DELIMITER $$
create procedure THEM_SV(
	 t_mssv VARCHAR(10),
	 t_hoten VARCHAR(45),
	 t_gioitinh char(1),
	 t_ngaySinh DATE,
	 t_noiSinh VARCHAR(40),
	 t_diaChi VARCHAR(100),
	 t_makhoa VARCHAR(8)
) 
BEGIN
	DECLARE dem INT DEFAULT 0;
	SET dem = (SELECT COUNT(*) FROM sinhvien WHERE mssv = t_mssv);
	if dem > 0 then
		SELECT 'Đã tồn tại';
		SELECT *,COUNT(*) FROM sinhvien WHERE mssv = t_mssv;
	else
		SELECT 'Chưa tồn tại';
		INSERT INTO sinhvien (mssv,hoten,gioiTinh,ngaySinh,noiSinh,DiaChi,maKhoa)
		VALUES(t_mssv,t_hoten,t_gioitinh,t_ngaySinh,t_noiSinh,t_diaChi,t_makhoa);
	END if;
END; $$
DELIMITER ;

-- 2. Tạo hàm xóa sinh viên từ bảng sinh viên
DELIMITER $$
create procedure XOA_SV(maSV char(8)) 
BEGIN
	DECLARE dem INT;
	-- Tìm mã số sinh viên
	SET dem = (SELECT COUNT(*) FROM sinhvien WHERE mssv = maSV);
	if (dem > 0) then
		DELETE FROM ketqua WHERE mssv = maSV;
		DELETE FROM sinhvien WHERE mssv = maSV;
		SELECT 'Xóa thành công';
	else
		SELECT 'Không tìm thấy. Xóa thất bại';
	END if;
END; $$
DELIMITER ;

-- 3. Tao hàm xem điểm trung bình của một sinh viên
DELIMITER $$
create procedure DIEM_TB(maSV char(8)) 
BEGIN
	DECLARE dem INT;
	-- Tìm mã số sinh viên
	SET dem = (SELECT COUNT(*) FROM ketqua WHERE mssv = maSV);
	if (dem > 0) then
		SELECT SUM(kq.diem * hq.soTinChi)/SUM(hq.soTinChi) DiemTrungBinh
		FROM ketqua kq INNER JOIN hocphan hq ON kq.maHP = hq.maHP
							INNER JOIN sinhvien sv ON sv.mssv = kq.mssv
		WHERE kq.mssv = maSV				
		GROUP BY (sv.mssv);
	else
		SELECT '-1';
	END if;
END; $$
DELIMITER ;

-- 4. hàm in bảng điểm trung bình của sinh viên theo khoa
DELIMITER $$
create procedure Bang_DIEM_TB(MKhoa char(8)) 
BEGIN
	DECLARE dem INT;
	-- Tìm mã khoa
	SET dem = (SELECT COUNT(*) FROM khoa WHERE maKhoa = MKhoa);
	if (dem > 0) then
		SELECT sv.mssv, sv.hoten,SUM(kq.diem * hq.soTinChi)/SUM(hq.soTinChi) DiemTrungBinh
		FROM ketqua kq INNER JOIN hocphan hq ON kq.maHP = hq.maHP
							INNER JOIN sinhvien sv ON sv.mssv = kq.mssv
							INNER JOIN khoa k ON sv.maKhoa = k.maKhoa
		WHERE k.maKhoa = MKhoa	
		GROUP BY (sv.mssv);
	else
		SELECT '-1';
	END if;
END; $$
DELIMITER ;

-- 5. Hàm xét tốt nghiệp trên sinh viên
DELIMITER $$
create procedure TotNghiep(MaSV char(8)) 
BEGIN
	DECLARE dem INT;
	DECLARE hang FLOAT;
	-- Tìm sinh viên
	SET dem = (SELECT COUNT(*) FROM sinhvien WHERE mssv = MaSV);
	if (dem > 0) then
		SET hang = (SELECT SUM(kq.diem * hq.soTinChi)/SUM(hq.soTinChi) AS DiemTrungBinh
		FROM ketqua kq INNER JOIN hocphan hq ON kq.maHP = hq.maHP
							INNER JOIN sinhvien sv ON sv.mssv = kq.mssv
		WHERE kq.mssv = MaSV
		GROUP BY(sv.mssv));
		if(hang > 4) then
			SELECT 'TRUE';
		else
			SELECT 'FALSE';
		END if;
	else
		SELECT '-1';
	END if;
END; $$
DELIMITER ;

-- 6. Xét loại tốt nghiệp trên một sinh viên
DELIMITER $$
create procedure Loai_Tot_Nghiep(MaSV char(8)) 
BEGIN
	DECLARE dem INT;
	DECLARE hang FLOAT;
	-- Tìm sinh viên
	SET dem = (SELECT COUNT(*) FROM sinhvien WHERE mssv = MaSV);
	if (dem > 0) then
		SET hang = (SELECT SUM(kq.diem * hq.soTinChi)/SUM(hq.soTinChi) AS DiemTrungBinh
		FROM ketqua kq INNER JOIN hocphan hq ON kq.maHP = hq.maHP
							INNER JOIN sinhvien sv ON sv.mssv = kq.mssv
		WHERE kq.mssv = MaSV
		GROUP BY(sv.mssv));
		if(hang >= 9 && hang <=10) then
			SELECT 'Xuất sắc';
		ELSEIF (hang >= 8 && hang <= 8.9) then
			SELECT 'Giỏi';
		ELSEIF (hang >= 6.5 && hang <= 7.9) then
			SELECT 'Khá';
		ELSEIF (hang >= 5.5 && hang <= 6.5) then
			SELECT 'Trung bình';
		ELSEIF (hang >= 4 && hang < 5.5) then
			SELECT 'Yếu';
		ELSEIF (hang < 4) then
			SELECT 'Kém';
		END if;
	else
		SELECT '-1';
	END if;
END; $$
DELIMITER ;

-- 7.Liệt kê sinh viên tốt nghiệp dựa trên mã khoa và dùng con trỏ
DELIMITER $$
CREATE PROCEDURE SV_TOT_NGHIEP(MKhoa CHAR(8))
BEGIN
    -- Khai báo biến lưu trữ dữ liệu từ con trỏ
    DECLARE mssv CHAR(8);
    DECLARE hoten VARCHAR(50);
    DECLARE Tot_Nghiep FLOAT;
    DECLARE LoaiTotNghiep VARCHAR(50);
    DECLARE done INT DEFAULT 0;

    -- Tạo con trỏ
    DECLARE C CURSOR FOR
        SELECT sv.mssv, sv.hoten, TotNghiep(sv.mssv), Loai_Tot_Nghiep(sv.mssv)
        FROM ketqua kq
        INNER JOIN hocphan hq ON kq.maHP = hq.maHP
        INNER JOIN sinhvien sv ON sv.mssv = kq.mssv
        INNER JOIN khoa k ON sv.maKhoa = k.maKhoa
        WHERE k.maKhoa = MKhoa
        GROUP BY (sv.mssv)
		  HAVING TotNghiep(sv.mssv) > 0;

    -- Khai báo NOT FOUND handler để xử lý lỗi không tìm thấy dữ liệu
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Mở con trỏ
    OPEN C;

    -- Bắt đầu vòng lặp
    WHILE done = 0 DO
        FETCH C INTO mssv, hoten, Tot_Nghiep, LoaiTotNghiep;
        IF NOT done THEN
            SELECT mssv, hoten, Tot_Nghiep, LoaiTotNghiep;
        END IF;
    END WHILE;
    	

    -- Đóng con trỏ
    CLOSE C;
END$$
DELIMITER ;

-- 8. Hàm trả về số lượng sinh viên trong một khoa nào đó, dựa trên tên khoa
DELIMITER $$
CREATE FUNCTION SL_SV_KHOA( TKhoa VARCHAR(50))	RETURNS INT 
BEGIN
	DECLARE dem INT;
	DECLARE soLuong INT;
	-- Tìm sinh viên
	SET dem = (SELECT COUNT(*) FROM khoa WHERE tenKhoa = TKhoa);
	if (dem > 0) then
		SET soLuong = (SELECT COUNT(*)
							FROM sinhvien sv INNER JOIN khoa ON sv.maKhoa = khoa.maKhoa
							WHERE khoa.tenKhoa = TKhoa	
							GROUP BY (khoa.maKhoa));
		RETURN soLuong;
	else
		RETURN -1;
	END if;
END;$$
DELIMITER ;

-- 9. Trả về danh sách sinh viên dựa trên tên loại tốt nghiệp
DELIMITER $$
CREATE PROCEDURE SV_Loai(in tenLoai VARCHAR(20))
BEGIN
    SELECT mssv,hoten, Loai_Tot_Nghiep(mssv) 
	FROM sinhvien
	WHERE Loai_Tot_Nghiep(mssv) = tenLoai;
END$$
DELIMITER ;

-- 10. Đặt quy luật không được phép xóa sinh viên từ khoa CNTT&TT
DELIMITER $$
CREATE TRIGGER KhongXoaSinhVienSNTT BEFORE DELETE	-- Sự kiện này bắt đầu trước sự kiện xóa
ON sinhvien
FOR EACH ROW -- Kiểm tra trên mỗi dòng
BEGIN
	DECLARE mak VARCHAR(10);
	
	SELECT maKhoa INTO mak
	FROM khoa
	WHERE maKhoa = OLD.maKhoa;

	if OLD.maKhoa = 'CNTT&TT' then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT ='Không được quyền xóa sinh viên từ khoa CNTT&TT';
	END if;
END;$$
DELIMITER ;