-- Step 1: Create a master key in the master database
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourStrongPasswordHere';
GO

-- Step 2: Create a server certificate for TDE
CREATE CERTIFICATE MyServerCertificate
WITH SUBJECT = 'TDE Certificate for testDB';
GO

-- Step 3: Switch to the target database
USE testDB;
GO

-- Step 4: Create a database encryption key and specify the encryption algorithm
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyServerCertificate;
GO

-- Step 5: Backup the TDE Certificate to the filesystem
BACKUP CERTIFICATE MyServerCertificate
TO FILE = 'C:\Backup\MyServerCertificate.cer'
WITH PRIVATE KEY (
    FILE = 'C:\Backup\MyServerCertificate.key',
    ENCRYPTION BY PASSWORD = 'AnotherStrongPassword'
);
GO

-- Step 6: Enable Transparent Data Encryption (TDE) for the database
ALTER DATABASE testDB SET ENCRYPTION ON;
GO

-- Monitor TDE encryption progress
SELECT 
    DB_NAME(database_id) AS DatabaseName,
    encryption_state,
    CASE encryption_state
        WHEN 0 THEN 'No encryption'
        WHEN 1 THEN 'Unencrypted'
        WHEN 2 THEN 'Encryption in progress'
        WHEN 3 THEN 'Encrypted'
        WHEN 4 THEN 'Key change in progress'
        WHEN 5 THEN 'Decryption in progress'
        WHEN 6 THEN 'Encryption paused'
    END AS EncryptionStateDescription,
    percent_complete AS EncryptionPercentComplete,
    key_algorithm AS EncryptionAlgorithm,
    key_length AS KeyLength
FROM sys.dm_database_encryption_keys
WHERE database_id = DB_ID('testDB');
GO

/* 
-- Disable TDE 
 ALTER DATABASE testDB SET ENCRYPTION OFF;
 GO
*/