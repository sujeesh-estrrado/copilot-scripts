IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_NewFloor]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATe procedure [dbo].[SP_Insert_NewFloor](@Floor_Name varchar(200),@Floor_Code varchar(50),@Floor_DelStatus bit)      
AS      
      
IF EXISTS(SELECT Floor_Name  FROM Tbl_Floor WHERE Floor_Name=@Floor_Name and Floor_DelStatus=@Floor_DelStatus)      
      
BEGIN      
RAISERROR(''Your data already Exist.'',16,1);      
END      
ELSE      
BEGIN      
INSERT INTO dbo.Tbl_Floor(Floor_Name,Floor_Code,Floor_DelStatus) VALUES(@Floor_Name,@Floor_Code,@Floor_DelStatus)      
SELECT SCOPE_IDENTITY()  
END

    ');
END;
