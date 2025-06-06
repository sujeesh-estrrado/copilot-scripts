IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Visa_Log]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Sp_Get_Visa_Log]
@Candidate_Id bigint
as
begin


SELECT 
    VL.Candidate_Id,
  VL.Log_Details,
  --Convert(varchar(10),VL.Date,120) as Date,
  FORMAT(VL.Date, ''dd/MM/yyyy'') AS Date,
  VL.Old,
  VL.new,
  Case when Changed_By=1 then ''Admin''
  else Concat(E.Employee_FName,'' '',E.Employee_LName,'' ('',Tr.role_Name,'')'')
  --else Concat(Employee_FName,'' '',Employee_LName) 
  end as Changed_By
FROM Tbl_Visa_Log VL LEFT JOIN Tbl_Employee E on VL.Changed_By=E.Employee_Id
LEFT JOIN Tbl_RoleAssignment TRA on TRA.employee_id=E.Employee_Id
LEFT JOIN tbl_Role TR on TR.role_Id=TRA.role_id
WHERE Candidate_Id = @Candidate_Id

order by VL.Log_Id desc
end
    ')
END
