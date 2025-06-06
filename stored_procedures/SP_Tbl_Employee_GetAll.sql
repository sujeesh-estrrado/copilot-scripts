IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Employee_GetAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('                                         
CREATE procedure [dbo].[SP_Tbl_Employee_GetAll] -- '''',0,0,4                                       
 (    
 @SearchTerm varchar(max) ='''',    
 @pagesize bigint=0,    
 @CurrentPage  bigint=0,    
 @Flag bigint=0    
    
 )                                  
as                                            
                                            
begin                                            
    if (@Flag=0)    
 begin                                        
  SELECT distinct e.Employee_Id,                            
        e.Employee_Id AS ID, concat(e.Employee_FName,'' '',e.Employee_LName) AS [Employee Name], ISNULL(d.Dept_Name, '''') AS Dept_Name, e.Employee_FName + '' '' + e.Employee_LName + '' '' AS Employee, e.Identification_No,     
        e.Employee_Id_Card_No AS [ID No], e.Employee_Type, e.Blood_Group AS [Blood Group], ISNULL(d.Dept_Name, '''') AS Department, e.Employee_FName, e.Employee_LName,     
  CONVERT(VARCHAR(10), CAST( e.Employee_DOB AS DATETIME), 103)as Employee_DOB,    
  e.Employee_Gender,e.Employee_Permanent_Address, e.Employee_Present_Address, e.Employee_Phone, e.Employee_Mail, e.Employee_Mobile, e.Employee_Martial_Status, e.Blood_Group, e.Employee_Id_Card_No, e.Employee_Nationality,     
        e.Employee_State, ISNULL(e.Employee_Experience_If_Any, 0) AS Employee_Experience_If_Any, e.Employee_Father_Name, e.Employee_Nominee_Name, e.Employee_Nominee_Relation, e.Employee_Nominee_Phone,     
        e.Employee_Nominee_Address, e.Employee_Status, e.Employee_Type AS Expr1, ISNULL(e.Employee_Img, '''') AS Employee_Img, e.Employee_Aadhar,     
  --ed.Employee_Degree, ed.Employee_College, ed.Employee_University,     
        --ed.Employee_PassOutYear, ed.Employee_Speciality, ed.Employee_RegNo, ed.Employee_Education_State,    
  e.Employee_FName + '' '' + e.Employee_LName AS Employee_Name, ISNULL(eo.Department_Id, 0) AS Department_Id,     
        CONVERT(VARCHAR(10), CAST( e.Employee_DOB AS DATETIME), 103) AS DOB, e.Employee_Gender AS Gender, e.Employee_Mobile AS Mobile, CONVERT(VARCHAR(10),CAST( e.Employee_DOB AS DATETIME), 103) AS DOJ, eo.Employee_Official_Id, CONVERT(VARCHAR(10),CAST(eo
  
    
    
.Employee_DOJ AS DATETIME), 103) as Employee_DOJ, eo.Employee_Probation_Period,     
        CONVERT(VARCHAR(10), CAST(  eo.Employee_Confirmation_Date AS DATETIME), 103) as Employee_Confirmation_Date, eo.Employee_Pan_No, eo.Employee_Esi_No, eo.Employee_Payment_mode, eo.Employee_Bank_Account_No, eo.Employee_Bank_Name, eo.Employee_Mode_Job,
  
    
    
     
        eo.Employee_Reporting_Staff, eo.Employee_Official_Status, eo.Employee_Id, eo.Department_Id AS Expr2, eo.PFNO, eo.BasicSalary, eo.SocsoNo, eo.KwspNo, eo.Insurance_detail, eo.Designation_Id, eo.Created_Date,     
        eo.Updated_Date, eo.Delete_Status, e.Emergency_Name, e.Emergency_Number, eo.Insurance_detail AS Expr3, e.Spouse_FName, e.Spouse_LName, e.Spouse_IC_No, e.NoofChildren, e.Spouse_Email, e.Spouse_MobileNo,      
        eo.Employee_Reporting_Staff AS Expr4, e.Employee_postcode,    
  -- ed.Employee_PassOutMonth, ed.Employee_RegDate,ed.Employee_Education_Id,    
  e.Employee_City,e.Employee_Country , CONVERT(VARCHAR(10),CAST( eo.ResignedDate AS DATETIME), 103) as ResignedDate,  
   CONVERT(VARCHAR(10),CAST( eo.ExtendResignedDate AS DATETIME), 103) as ExtendResignedDate,  
   CONVERT(VARCHAR(10),CAST( eo.OfficialLastDate AS DATETIME), 103) as OfficialLastDate  ,teu.LMS_access
  FROM dbo.Tbl_Employee AS e LEFT OUTER JOIN    
        dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id left JOIN    
        --  dbo.Tbl_Employee_Education AS ed ON ed.Employee_Id = e.Employee_Id LEFT OUTER JOIN    
        dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id  
        left join Tbl_Employee_User teu on teu.Employee_Id= e.Employee_Id
 WHERE   (e.Employee_Status = 0 )    
 end    
if(@Flag=1)    
begin    
    
 SELECT distinct count (e.Employee_Id) AS ID    
FROM            dbo.Tbl_Employee AS e LEFT OUTER JOIN    
                         dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id left JOIN    
                       --  dbo.Tbl_Employee_Education AS ed ON ed.Employee_Id = e.Employee_Id LEFT OUTER JOIN    
                         dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id    
WHERE        (e.Employee_Status = 0 )     
and( (concat(e.Employee_FName,'' '',e.Employee_LName) like concat(''%'',@SearchTerm ,''%''))    
or d.Dept_Name  like concat(''%'',@SearchTerm ,''%'')     
or e.Employee_Id_Card_No like concat(''%'',@SearchTerm ,''%'')     
    
    
 or e.Employee_Gender like concat(''%'',@SearchTerm ,''%'')     
 or e.Employee_Permanent_Address like concat(''%'',@SearchTerm ,''%'')     
 or  e.Employee_Present_Address like concat(''%'',@SearchTerm ,''%'')     
 or  e.Employee_Phone like concat(''%'',@SearchTerm ,''%'')     
 or  e.Employee_Mail like concat(''%'',@SearchTerm ,''%'')     
 or  e.Employee_Mobile like concat(''%'',@SearchTerm ,''%'')     
 or eo.Employee_DOJ like concat(''%'',@SearchTerm ,''%'')     
)    
 end    
if(@Flag=2)    
    
    
    
 begin    
    
    
  SELECT distinct e.Employee_Id,                           
                            
 e.Employee_Id AS ID, concat(e.Employee_FName,'' '',e.Employee_LName) AS [Employee Name], ISNULL(d.Dept_Name, '''') AS Dept_Name, e.Employee_FName + '' '' + e.Employee_LName + '' '' AS Employee, e.Identification_No,     
                         e.Employee_Id_Card_No AS [ID No], e.Employee_Type, e.Blood_Group AS [Blood Group], ISNULL(d.Dept_Name, '''') AS Department, e.Employee_FName, e.Employee_LName,     
       CONVERT(VARCHAR(10), CAST( e.Employee_DOB AS DATETIME), 103)as Employee_DOB,    
       e.Employee_Gender,e.Employee_Permanent_Address, e.Employee_Present_Address, e.Employee_Phone, e.Employee_Mail, e.Employee_Mobile, e.Employee_Martial_Status, e.Blood_Group, e.Employee_Id_Card_No, e.Employee_Nationality,     
                         e.Employee_State, ISNULL(e.Employee_Experience_If_Any, 0) AS Employee_Experience_If_Any, e.Employee_Father_Name, e.Employee_Nominee_Name, e.Employee_Nominee_Relation, e.Employee_Nominee_Phone,     
                         e.Employee_Nominee_Address, e.Employee_Status, e.Employee_Type AS Expr1, ISNULL(e.Employee_Img, '''') AS Employee_Img, e.Employee_Aadhar,     
       e.Employee_FName + '' '' + e.Employee_LName AS Employee_Name, ISNULL(eo.Department_Id, 0) AS Department_Id,     
                         CONVERT(VARCHAR(10), CAST( e.Employee_DOB AS DATETIME), 103) AS DOB, e.Employee_Gender AS Gender, e.Employee_Mobile AS Mobile, CONVERT(VARCHAR(10),CAST( e.Employee_DOB AS DATETIME), 103) AS DOJ, eo.Employee_Official_Id, 
                         CONVERT(VARCHAR(10),CAST(eo.Employee_DOJ AS DATETIME), 103) as Employee_DOJ, eo.Employee_Probation_Period,     
                         CONVERT(VARCHAR(10), CAST(  eo.Employee_Confirmation_Date AS DATETIME), 103) as Employee_Confirmation_Date, eo.Employee_Pan_No, eo.Employee_Esi_No, eo.Employee_Payment_mode, eo.Employee_Bank_Account_No, eo.Employee_Bank_Name,     
       eo.Employee_Mode_Job,     
                         eo.Employee_Reporting_Staff, eo.Employee_Official_Status, eo.Employee_Id, eo.Department_Id AS Expr2, eo.PFNO, eo.BasicSalary, eo.SocsoNo, eo.KwspNo, eo.Insurance_detail, eo.Designation_Id, eo.Created_Date,     
                         eo.Updated_Date, eo.Delete_Status, e.Emergency_Name, e.Emergency_Number, eo.Insurance_detail AS Expr3, e.Spouse_FName, e.Spouse_LName, e.Spouse_IC_No, e.NoofChildren, e.Spouse_Email, e.Spouse_MobileNo,      
                         eo.Employee_Reporting_Staff AS Expr4, e.Employee_postcode,    
       e.Employee_City,e.Employee_Country  , CONVERT(VARCHAR(10),CAST( eo.ResignedDate AS DATETIME), 103) as ResignedDate,  
   CONVERT(VARCHAR(10),CAST( eo.ExtendResignedDate AS DATETIME), 103) as ExtendResignedDate,  
   CONVERT(VARCHAR(10),CAST( eo.OfficialLastDate AS DATETIME), 103) as OfficialLastDate ,
   e.Active_Status -- Added column here
    
FROM          dbo.Tbl_Employee AS e LEFT OUTER JOIN    
                         dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id left JOIN    
                       --  dbo.Tbl_Employee_Education AS ed ON ed.Employee_Id = e.Employee_Id LEFT OUTER JOIN    
                         dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id    
WHERE        (e.Employee_Status = 0 )     
             and( (concat(e.Employee_FName,'' '',e.Employee_LName) like concat(''%'',@SearchTerm ,''%''))    
or d.Dept_Name  like concat(''%'',@SearchTerm ,''%'')     
or e.Employee_Id_Card_No like concat(''%'',@SearchTerm ,''%'')     
    
    
 or e.Employee_Gender like concat(''%'',@SearchTerm ,''%'')     
 or e.Employee_Permanent_Address like concat(''%'',@SearchTerm ,''%'')     
 or  e.Employee_Present_Address like concat(''%'',@SearchTerm ,''%'')     
 or  e.Employee_Phone like concat(''%'',@SearchTerm ,''%'')     
 or  e.Employee_Mail like concat(''%'',@SearchTerm ,''%'')     
 or  e.Employee_Mobile like concat(''%'',@SearchTerm ,''%'')     
 or eo.Employee_DOJ like concat(''%'',@SearchTerm ,''%'')     
)    
--order by concat(e.Employee_FName,'' '',e.Employee_LName)--ID    
order by e.Employee_Id desc
   OFFSET @PageSize * (@CurrentPage - 1) ROWS    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);    
    
 end    
end 
    ')
END
