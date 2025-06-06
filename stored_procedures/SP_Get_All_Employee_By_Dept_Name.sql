IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_By_Dept_Name]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_Get_All_Employee_By_Dept_Name]  
(            
                
@CurrentPage int = null,            
@PageSize int = null  ,        
@SearchTerm varchar(100)          
)            
                
AS            
            
BEGIN            
    SET NOCOUNT ON            
            
    DECLARE @SqlString nvarchar(max)        
Declare @SqlStringWithout nvarchar(max)            
    Declare @UpperBand int            
    Declare @LowerBand int                    
                
    SET @LowerBand  = (@CurrentPage - 1) * @PageSize            
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                
            
    BEGIN            
             
      
      
IF @SearchTerm IS NOT NULL      
      
BEGIN      
      
 SET @SqlString=''WITH tempProfile AS            
        (SELECT    
Tbl_Employee_Official.Employee_Id as ID,  
Tbl_Employee.Employee_FName +'''' ''''+Tbl_Employee.Employee_LName as [Employee Name] ,  
Tbl_Employee.Employee_Id_Card_No as [ID No],  
Tbl_Employee.Blood_Group as [Blood Group],  
Tbl_Emp_Department.Dept_Name as Department,   
Tbl_Employee.Employee_DOB as DOB,  
Tbl_Employee.Employee_Gender as Gender,              
Tbl_Employee.Employee_Mobile as Mobile,  
Tbl_Employee_Official.Employee_DOJ as DOJ,  
  
ROW_NUMBER() over (ORDER BY Tbl_Employee.Employee_Id DESC) AS RowNumber  
  
    
FROM         Tbl_Employee_Official INNER JOIN    
             Tbl_Employee ON Tbl_Employee_Official.Employee_Id = Tbl_Employee.Employee_Id INNER JOIN    
             Tbl_Emp_Department ON Tbl_Employee_Official.Department_Id = Tbl_Emp_Department.Dept_Id    
where Tbl_Employee.Employee_Status=0  
  
and  (Tbl_Emp_Department.Dept_Name like  ''''''+ @SearchTerm+''%''''  
)      
      
           
        )                 
            
        SELECT  
ID,  
[Employee Name],  
[ID No],  
[Blood Group],  
Department,  
DOB,  
Gender,  
Mobile,  
DOJ,  
RowNumber  
  
FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
END      
      
--IF @SearchTerm is null        
      
 IF (@SearchTerm is null or @SearchTerm = '''')      
      
begin      
      
 SET @SqlString=''WITH tempProfile AS            
        (                                
             SELECT  
Tbl_Employee_Official.Employee_Id as ID,  
Tbl_Employee.Employee_FName +'''' ''''+Tbl_Employee.Employee_LName as [Employee Name] ,  
Tbl_Employee.Employee_Id_Card_No as [ID No],  
Tbl_Employee.Blood_Group [Blood Group],  
Tbl_Emp_Department.Dept_Name as Department,   
Tbl_Employee.Employee_DOB as DOB,  
Tbl_Employee.Employee_Gender as Gender,              
Tbl_Employee.Employee_Mobile as Mobile,  
Tbl_Employee_Official.Employee_DOJ as DOJ,  
  
ROW_NUMBER() over (ORDER BY Tbl_Employee.Employee_Id DESC) AS RowNumber  
    
FROM         Tbl_Employee_Official INNER JOIN    
             Tbl_Employee ON Tbl_Employee_Official.Employee_Id = Tbl_Employee.Employee_Id INNER JOIN    
             Tbl_Emp_Department ON Tbl_Employee_Official.Department_Id = Tbl_Emp_Department.Dept_Id    
where Tbl_Employee.Employee_Status=0  
  
and  (Tbl_Emp_Department.Dept_Name like  ''''''+ @SearchTerm+''%''''  
)      
      
           
        )                 
            
        SELECT  
ID,  
[Employee Name],  
[ID No],  
[Blood Group],  
Department,  
DOB,  
Gender,  
Mobile,  
DOJ,  
RowNumber  
  
FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
end      
      
   EXEC sp_executesql @SqlString            
        
            
    END            
END
    ')
END
