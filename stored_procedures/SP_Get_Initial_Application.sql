IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Initial_Application]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Get_Initial_Application](@Intial_Application_Id bigint)  
as begin  
  
select Intial_Application_Id as InitialAppID,Course_Level_Id as [Course Level],Course_Category_Id as [Course Category],Department_Id as [Department],[Name],DOB,Mobile,Email,New_Admission_id as AdmissionID
  
from dbo.Tbl_Initial_Application_Registration where Intial_Application_Id=@Intial_Application_Id  
  
end
   ')
END;
