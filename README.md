# SQL Test Data Generation

This repo has basic scripts to generate data for infrastructure-related test cases on MSSQL.

## 100 GB Database

After installing MSSQL, simply run the ``100GB.sql`` file and it will create a database and populate it with 300 million rows of data which equates to roughly 100GB of data.

![Database Size](/media/100GB.png)

You can change the size of the database by modifying the number of rows added here:
``DECLARE @targetRows BIGINT = 300000000;``.

*Note: This process is primarily data write operations and will not have much CPU impact.*


## TDE Encryption

Run the ``TDE.sql`` script, and you can re-run the monitor section to see an updated status of the encryption process.
