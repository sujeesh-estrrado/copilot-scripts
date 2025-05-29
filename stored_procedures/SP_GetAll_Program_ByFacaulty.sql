IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Program_ByFacaulty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_Program_ByFacaulty] --3
(
@Faculty_Id Bigint=0
)                           
AS                            
BEGIN                            
  if(@Faculty_Id=0)     
  begin                   
SELECT CBD .Batch_Id,CL.Course_Level_Name,Cl.Course_Level_Id,
CBD .Duration_Id as DurationID,      
CBD .Batch_Id as ID,
O.Organization_Name,                          
CBD .Batch_Code as BatchCode,                            
convert(varchar(50),CBD .Batch_From,103) as Batch_From,             
convert(varchar(50),CBD .Batch_To,103) as Batch_To,
CBD .Study_Mode ,                 
PD.Program_Duration_Type,                  
PD.Program_Duration_Year,           
PD.Program_Duration_Month ,  
convert(varchar(50),CBD .Intro_Date,103) as Intro_Date,                
CBD .SyllubusCode,      
CD.Course_Category_Id,  Tbl_Department.Department_Name, Tbl_Department.Department_Id as programid,   
CC.Course_Category_Name as CategoryName,CBD .SyllubusCode             
                  
                         
FROM dbo.Tbl_Course_Batch_Duration CBD              
INNER JOIN Tbl_Organzations O on O.Organization_Id=CBD .Org_Id             
INNER JOIN Tbl_Program_Duration PD on CBD .Duration_Id=PD.Duration_Id                             
inner join  dbo.Tbl_Department on Tbl_Department.Department_Id=PD.Program_Category_Id               
inner join dbo.Tbl_Course_Department CD on CD.Department_Id=Tbl_Department.Department_Id            
inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id  
inner join Tbl_Course_Level CL on    Tbl_Department.GraduationTypeId=CL.Course_Level_Id       
WHERE Batch_DelStatus=0   and Tbl_Department.Department_Status = 0             
                            
Order by Batch_Id DESC                          
  end
  else
  begin
  SELECT CBD .Batch_Id,CL.Course_Level_Name,Cl.Course_Level_Id,
CBD .Duration_Id as DurationID,      
CBD .Batch_Id as ID,
O.Organization_Name,                          
CBD .Batch_Code as BatchCode,                            
convert(varchar(50),CBD .Batch_From,103) as Batch_From,             
convert(varchar(50),CBD .Batch_To,103) as Batch_To,
CBD .Study_Mode ,                 
PD.Program_Duration_Type,                  
PD.Program_Duration_Year,           
PD.Program_Duration_Month ,  
convert(varchar(50),CBD .Intro_Date,103) as Intro_Date,                
CBD .SyllubusCode,      
CD.Course_Category_Id,  Tbl_Department.Department_Name, Tbl_Department.Department_Id as programid,   
CC.Course_Category_Name as CategoryName,CBD .SyllubusCode             
                  
                         
FROM dbo.Tbl_Course_Batch_Duration CBD              
INNER JOIN Tbl_Organzations O on O.Organization_Id=CBD .Org_Id             
INNER JOIN Tbl_Program_Duration PD on CBD .Duration_Id=PD.Duration_Id                             
inner join  dbo.Tbl_Department on Tbl_Department.Department_Id=PD.Program_Category_Id               
inner join dbo.Tbl_Course_Department CD on CD.Department_Id=Tbl_Department.Department_Id            
inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id  
inner join Tbl_Course_Level CL on    Tbl_Department.GraduationTypeId=CL.Course_Level_Id       
WHERE Batch_DelStatus=0   and Tbl_Department.Department_Status = 0    and CL.Course_Level_Id= @Faculty_Id      
  end

                            
END 
    ')
END
