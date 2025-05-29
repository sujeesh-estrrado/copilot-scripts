IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Patient_Treatment_History_By_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[Sp_Get_Patient_Treatment_History_By_Id] 
@patient_id bigint

AS
BEGIN

select
    PDM.Transfer_Date,TE.Employee_FName+'' ''+TE.Employee_LName as Doctor_name,
TD.Department_Name,PDM.Chief_Complaint,PDM.History_of_Present_illness
from 
dbo.Tbl_Patient_Doctor_Mapping PDM

left join dbo.Tbl_Patient_Registration PR on
PDM.Patient_Id=PR.Patient_Id

left join dbo.Tbl_Department TD
on PDM.Department_Id=TD.Department_Id

left join dbo.Tbl_Employee TE
on PDM.Doctor_id=Employee_Id

where PR.Patient_Id=@patient_id

END
    ')
END
GO