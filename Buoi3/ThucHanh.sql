# 1.1 Thêm 2 dữ liệu vào table account
START TRANSACTION;
INSERT INTO trans1(AccountID,Balance) VALUES(1,1000.00);
INSERT INTO trans2(AccountID,Balance) VALUES(2,2000.00);
COMMIT;

#1.2 Thực hiện cập nhập số tiền của 2 tài khoản
START TRANSACTION;
UPDATE trans1 SET Balance = 2000.00 WHERE AccountID = '1';
UPDATE trans2 SET Balance = 3000.00 WHERE AccountID = '2';
COMMIT;

#1.3 Chuyển 500.00 từ tài khoản 1 sang tài khoản 2. Giao dịch thành công số dư
#của tài khoản 1 giảm đi 500.00 và số dư của tài khoản 2 tăng lên 500.00

START TRANSACTION;
UPDATE trans1 SET Balance = Balance -500.00
WHERE AccountID = '1';

UPDATE trans2 SET Balance = Balance +500.00
WHERE AccountID = '2';
COMMIT;

#1.4Chuyển tiền từ tài khoản 1 sang tài khoản 2, nhưng có một lỗi xảy ra (ví dụ:
#không đủ tiền trong tài khoản 1). Sau đó, hủy bỏ giao dịch (ROLLBACK)
DELIMITER $$
START TRANSACTION;

UPDATE trans1 SET Balance = Balance -3000.00 WHERE AccountID = 1;
UPDATE trans2 SET Balance = Balance +3000.00 WHERE AccountID = 2;
IF (SELECT Balance FROM trans1 WHERE AccountID = 1) < 0 THEN
	ROLLBACK;
ELSE 
	COMMIT;
END IF$$

DELIMITER ;

#2
#Giao dịch 1: giao dịch 1 để chuyển tiền từ tài khoản A (AccountID = 1) sang tài khoản B (AccountID = 2)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE TRANSACTION.trans1  SET Balance = Balance -100.00
WHERE AccountID = 1;
ROLLBACK;
#Giao dịch 2: giao dịch 2 để cập nhật số dư của tài khoản B (AccountID = 2).
START TRANSACTION;
UPDATE TRANSACTION.trans2 SET Balance = Balance +100.00
WHERE AccountID = 2 ;
COMMIT;

SELECT Balance FROM trans1 WHERE AccountID = 1
SELECT Balance FROM trans2 WHERE AccountID = 2 

#3.
#Giao dịch 1
START TRANSACTION;
UPDATE TRANSACTION.trans1 SET Balance = Balance + 100.00 WHERE AccountID = 1;
DO SLEEP(5);
#Giao dịch 2

START TRANSACTION;
UPDATE TRANSACTION.trans1 SET Balance = Balance - 100.00 WHERE AccountID = 1;
UPDATE TRANSACTION.trans1 SET Balance = Balance + 100.00 WHERE AccountID = 1;
COMMIT;