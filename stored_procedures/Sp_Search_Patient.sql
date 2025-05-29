IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Search_Patient]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Search_Patient]
@regdate datetime,
@visit datetime,
@dep bigint,
@doctor bigint
AS
BEGIN
	select
 PR.OP_Number,
Convert(varchar(10),PR.Registration_Date,103)as Reg_Date,
Convert(varchar(10),PR.Expiry_Date,103)as Exp_Date,
PR.Gender,PR.Patient_Id, 
PR.Contact_Number,
PR.First_Name+'' ''+PR.Last_Name as Patient_name,
TD.Department_Name,
TE.Employee_FName+'' ''+TE.Employee_LName as doctor_name

from 
dbo.Tbl_Patient_Doctor_Mapping PDM

left join dbo.Tbl_Patient_Registration PR on
PDM.Patient_Id=PR.Patient_Id

left join dbo.Tbl_Department TD
on PDM.Department_Id=TD.Department_Id

left join dbo.Tbl_Employee TE
on PDM.Doctor_id=Employee_Id

where


(PR.Registration_Date=@regdate and PDM.Transfer_Date=@visit and PDM.Doctor_id=@doctor and 
PDM.Department_Id=@dep)
or
(
PR.Registration_Date=@regdate or PDM.Transfer_Date=@visit or PDM.Doctor_id=@doctor or 
PDM.Department_Id=@dep
)
or
(
PDM.Transfer_Date=@visit and PDM.Doctor_id=@doctor
)
or
(
PDM.Transfer_Date=@visit and PDM.Doctor_id=@doctor and 
PDM.Department_Id=@dep
)

END
');
END;