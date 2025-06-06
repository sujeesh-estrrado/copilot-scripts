IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Tbl_Employee_Personal_Official_Get_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Tbl_Employee_Personal_Official_Get_By_Employee_Id] (  
@Employee_Id bigint)  
  
as  
  
begin  
Select 
E.Employee_Id,
E.Employee_FName+'' ''+Employee_LName as [Employee_Name],
E.Employee_DOB,
E.Employee_Gender,
E.Employee_Permanent_Address,
E.Employee_Mail,
E.Employee_Mobile,
E.Employee_Martial_Status,
E.Blood_Group,
E.Employee_Id_Card_No,
E.Employee_Nationality,
E.Employee_Experience_If_Any,
E.Employee_Father_Name,  
E.Employee_Nominee_Name,
E.Employee_Nominee_Relation,
E.Employee_Nominee_Phone,
E.Employee_Nominee_Address,
O.Employee_DOJ,
O.Employee_Probation_Period,
O.Employee_Confirmation_Date,
O.Employee_Pan_No,
O.Employee_Esi_No,
O.Employee_Payment_mode,
O.Employee_Bank_Account_No,
O.Employee_Bank_Name,
O.Employee_Mode_Job,
O.Employee_Reporting_Staff

from dbo.Tbl_Employee E

LEFT JOIN dbo.Tbl_Employee_Official O on O.Employee_Id=E.Employee_Id
Where E.Employee_Id=@Employee_Id
  
end
    ')
END
