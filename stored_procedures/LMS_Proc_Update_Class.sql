IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_Proc_Update_Class]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_Proc_Update_Class]
                    (@Class_Id bigint,@Class_Name varchar(200))
                    

AS

BEGIN

    UPDATE dbo.LMS_Tbl_Class
        SET    
               Class_Name                 = @Class_Name
             
              
              
        WHERE  Class_Id                   = @Class_Id

END
    ')
END
