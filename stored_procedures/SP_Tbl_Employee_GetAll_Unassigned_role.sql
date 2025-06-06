IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_GetAll_Unassigned_role]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                                            
CREATE Procedure [dbo].[SP_Tbl_Employee_GetAll_Unassigned_role]                                       
                                        
as                                        
                                        
begin                                        
                                        
SELECT distinct e.Employee_Id,ROW_NUMBER() over (ORDER BY e.Employee_Id DESC) AS RowNumber,                        
                        
 e.Employee_Id AS ID, e.Employee_FName + '' '' + e.Employee_LName + '' '' AS [Employee Name], ISNULL(d.Dept_Name, '''') AS Dept_Name, e.Employee_FName + '' '' + e.Employee_LName + '' '' AS Employee, e.Identification_No, 
                         e.Employee_Id_Card_No AS [ID No], e.Employee_Type, e.Blood_Group AS [Blood Group], ISNULL(d.Dept_Name, '''') AS Department, e.Employee_FName, e.Employee_LName, e.Employee_DOB, e.Employee_Gender, 
                         e.Employee_Permanent_Address, e.Employee_Present_Address, e.Employee_Phone, e.Employee_Mail, e.Employee_Mobile, e.Employee_Martial_Status, e.Blood_Group, e.Employee_Id_Card_No, e.Employee_Nationality, 
                         e.Employee_State, ISNULL(e.Employee_Experience_If_Any, 0) AS Employee_Experience_If_Any, e.Employee_Father_Name, e.Employee_Nominee_Name, e.Employee_Nominee_Relation, e.Employee_Nominee_Phone, 
                         e.Employee_Nominee_Address, e.Employee_Status, e.Employee_Type AS Expr1, ISNULL(e.Employee_Img, '''') AS Employee_Img, e.Employee_Aadhar,
                          e.Employee_FName + '' '' + e.Employee_LName AS Employee_Name, ISNULL(eo.Department_Id, 0) AS Department_Id, 
                         e.Employee_DOB AS DOB, e.Employee_Gender AS Gender, e.Employee_Mobile AS Mobile, eo.Employee_DOJ AS DOJ, eo.Employee_Official_Id, eo.Employee_DOJ, eo.Employee_Probation_Period, 
                         eo.Employee_Confirmation_Date, eo.Employee_Pan_No, eo.Employee_Esi_No, eo.Employee_Payment_mode, eo.Employee_Bank_Account_No, eo.Employee_Bank_Name, eo.Employee_Mode_Job, 
                         eo.Employee_Reporting_Staff, eo.Employee_Official_Status, eo.Employee_Id, eo.Department_Id AS Expr2, eo.PFNO, eo.BasicSalary, eo.SocsoNo, eo.KwspNo, eo.Insurance_detail, eo.Designation_Id, eo.Created_Date, 
                         eo.Updated_Date, eo.Delete_Status, e.Emergency_Name, e.Emergency_Number, eo.Insurance_detail AS Expr3, e.Spouse_FName, e.Spouse_LName, e.Spouse_IC_No, e.NoofChildren, e.Spouse_Email, e.Spouse_MobileNo, 
                         eo.Employee_Reporting_Staff AS Expr4, e.Employee_postcode, e.Employee_City,e.Employee_Country

FROM            dbo.Tbl_Employee AS e 
 LEFT OUTER JOIN
                         dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id left JOIN
                         dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id
WHERE        (e.Employee_Status = 0) and e.Employee_Id not in (select employee_id from Tbl_RoleAssignment)
end 

    ')
END
