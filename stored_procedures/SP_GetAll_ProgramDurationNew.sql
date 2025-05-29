IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_ProgramDurationNew]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetAll_ProgramDurationNew]  
(@facultyid bigint=0,
@flag bigint=0,
@org_id bigint=0,
@Program_Type varchar(50)='''',
@Modeofstudy varchar(10)='''')
AS          
BEGIN 
   if(@flag=0)
   begin      
  if(@facultyid=0)
    begin        
        SELECT PD.Duration_Id as ID,PD.Program_Org_Id,O.Organization_Name,PD.Program_Category_Id as CourseCatID,          
            PD.Program_Duration_Type as DurationType,          
            PD.Program_Duration_Year as [Year],PD.Program_Duration_Sem as [Sem],          
            PD.Program_Duration_Month as [Month],PD.Program_Duration_Days as [Days],          
            D.Department_Name as CategoryName ,  
            D.Course_Code,CL.Course_Level_Name ,
            CONCAT(D.Course_Code,''-'',D.Department_Name) as Program, D.Department_Id as ProgramID
          
        FROM  dbo.Tbl_Program_Duration PD  
            inner join dbo.Tbl_Organzations O on O.Organization_Id=PD.Program_Org_Id 
            
            left join   dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id   
            inner join Tbl_Course_Level CL on D.GraduationTypeId=CL.Course_Level_Id    
        WHERE PD.Program_Duration_DelStatus=0  and   Department_Status=0    and D.Active_Status=''Active''  

        order by CategoryName        
                   
    END
else
    begin
        SELECT PD.Duration_Id as ID,PD.Program_Org_Id,O.Organization_Name,PD.Program_Category_Id as CourseCatID,          
            PD.Program_Duration_Type as DurationType,          
            PD.Program_Duration_Year as [Year],PD.Program_Duration_Sem as [Sem],          
            PD.Program_Duration_Month as [Month],PD.Program_Duration_Days as [Days],          
            D.Department_Name as CategoryName ,  
            D.Course_Code ,CL.Course_Level_Name,
            CONCAT(D.Course_Code,''-'',D.Department_Name) as Program, D.Department_Id as ProgramID
          
        FROM  dbo.Tbl_Program_Duration PD  
            inner join dbo.Tbl_Organzations O on O.Organization_Id=PD.Program_Org_Id              
            left join   dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id  inner join Tbl_Course_Level CL on D.GraduationTypeId=CL.Course_Level_Id
            inner join Tbl_Emp_CourseDepartment_Allocation EA on D.GraduationTypeId=EA.Allocated_CourseDepartment_Id
        WHERE PD.Program_Duration_DelStatus=0  and   Department_Status=0    and D.Active_Status=''Active''  and EA.Employee_Id=@facultyid
        order by CategoryName      
    end
    end
       if(@flag=1)
   begin      
  if(@facultyid=0)
    begin        
        SELECT PD.Duration_Id as ID,PD.Program_Org_Id,O.Organization_Name,PD.Program_Category_Id as CourseCatID,          
            PD.Program_Duration_Type as DurationType,          
            PD.Program_Duration_Year as [Year],PD.Program_Duration_Sem as [Sem],          
            PD.Program_Duration_Month as [Month],PD.Program_Duration_Days as [Days],          
            D.Department_Name as CategoryName ,  
            D.Course_Code,CL.Course_Level_Name ,
            CONCAT(D.Course_Code,''-'',D.Department_Name) as Program, D.Department_Id as ProgramID
          
        FROM  dbo.Tbl_Program_Duration PD  
            inner join dbo.Tbl_Organzations O on O.Organization_Id=PD.Program_Org_Id 
            
            left join   dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id   
            inner join Tbl_Course_Level CL on D.GraduationTypeId=CL.Course_Level_Id    
        WHERE PD.Program_Duration_DelStatus=0  and   Department_Status=0    and D.Active_Status=''Active''  

        order by D.Course_Code        
                   
    END
else
    begin
        SELECT PD.Duration_Id as ID,PD.Program_Org_Id,O.Organization_Name,PD.Program_Category_Id as CourseCatID,          
            PD.Program_Duration_Type as DurationType,          
            PD.Program_Duration_Year as [Year],PD.Program_Duration_Sem as [Sem],          
            PD.Program_Duration_Month as [Month],PD.Program_Duration_Days as [Days],          
            D.Department_Name as CategoryName ,  
            D.Course_Code ,CL.Course_Level_Name,
            CONCAT(D.Course_Code,''-'',D.Department_Name) as Program, D.Department_Id as ProgramID
          
        FROM  dbo.Tbl_Program_Duration PD  
            inner join dbo.Tbl_Organzations O on O.Organization_Id=PD.Program_Org_Id              
            left join   dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id  inner join Tbl_Course_Level CL on D.GraduationTypeId=CL.Course_Level_Id
            inner join Tbl_Emp_CourseDepartment_Allocation EA on D.GraduationTypeId=EA.Allocated_CourseDepartment_Id
        WHERE PD.Program_Duration_DelStatus=0  and   Department_Status=0    and D.Active_Status=''Active''  and EA.Employee_Id=@facultyid
        order by D.Course_Code      
    end
    end
end
    ')
END
GO