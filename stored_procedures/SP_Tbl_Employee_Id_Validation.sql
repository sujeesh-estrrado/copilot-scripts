IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_Id_Validation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
            
CREATE procedure [dbo].[SP_Tbl_Employee_Id_Validation]          

  @Identification_No varchar(50)
 
as          
          
begin          
          
    
select * from Tbl_Employee where Identification_No = @Identification_No and Employee_Status=''0''
--select * from Tbl_Employee where Employee_Id_Card_No = @Identification_No and Employee_Status=''0''

END
    ')
END
