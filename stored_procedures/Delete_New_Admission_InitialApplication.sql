IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Delete_New_Admission_InitialApplication]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Delete_New_Admission_InitialApplication]    
@Nw_Admission_id bigint ,    
@Initial_App_id bigint      
               
AS              
               
BEGIN               
      if exists(select * From dbo.tbl_New_Admission where New_Admission_Id=@Nw_Admission_id)    
         
    begin    
         
        delete from  dbo.tbl_New_Admission where New_Admission_Id=@Nw_Admission_id    
         
    
       END       
           
           
         if exists(select * From dbo.tbl_Initial_Application_Registration where Intial_Application_Id=@Initial_App_id)    
         
   -- begin    
         
        delete from  dbo.tbl_Initial_Application_Registration where Intial_Application_Id=@Initial_App_id    
         
    
       END



    ')
END
