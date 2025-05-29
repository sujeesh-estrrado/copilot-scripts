IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert_Campus]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Proc_Insert_Campus]         
 (@Campus_Name varchar(200),@Campus_Code varchar(50))        
AS        
--IF EXISTS(SELECT Campus_Name FROM Tbl_Campus Where Campus_Name = @Campus_Name  and Campus_DelStatus = 0)   
if exists (SELECT Organization_Id as  Campus_Id,Organization_Name as  Campus_Name,Organization_Code Campus_Code  
  FROM [dbo].[Tbl_Organzations ] where Organization_DelStatus=0  and Organization_Name=@Campus_Name)
BEGIN        
RAISERROR (''Your data already Exist.'', -- Message text.        
               16, -- Severity.        
               1 -- State.        
               );        
END        
ELSE        
        
         
BEGIN         
         insert into [Tbl_Organzations ] (Organization_Name,Organization_Code,Organization_DelStatus) values 
         (@Campus_Name,@Campus_Code,0)
  --insert into Tbl_Campus(Campus_Name,Campus_Code)        
  --values(@Campus_Name,@Campus_Code)        
        
 SELECT SCOPE_IDENTITY()        
END  
  
    ')
END
GO