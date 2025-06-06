IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_NewFloor]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Update_NewFloor]   
(@Floor_Id bigint,    
@Floor_Name varchar(200),    
@Floor_Code varchar(50))      
AS      
    
IF  EXISTS (SELECT Floor_Name FROM Tbl_Floor WHERE            
 Floor_Name=@Floor_Name and Floor_Id<>@Floor_Id and Floor_DelStatus=0 )             
BEGIN              
RAISERROR(''Your data already Exist.'',16,1);              
END           
ELSE     
    
BEGIN      
UPDATE Tbl_Floor      
SET      
      
Floor_Name=@Floor_Name,      
Floor_Code=@Floor_Code      
      
WHERE Floor_Id=@Floor_Id and Floor_DelStatus=0      
       
END
    ')
END
