IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'dem')
CREATE LOGIN [dem] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [dem] FOR LOGIN [dem]
GO
