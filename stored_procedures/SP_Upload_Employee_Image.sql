IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Upload_Employee_Image]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Upload_Employee_Image]    
@Employee_Id  bigint,    
@Employee_Img varchar(max)    
AS    
    
    
    
BEGIN    
 Update Tbl_Employee   
 Set Employee_Img=@Employee_Img  
 Where Employee_Id=@Employee_Id    
END

    ')
END
