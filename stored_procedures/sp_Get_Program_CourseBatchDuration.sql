IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Program_CourseBatchDuration]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Get_Program_CourseBatchDuration]
(@intakeMasterID bigint =0,@ord_id int =0)
AS                  
BEGIN 
    SELECT CBD .Batch_Id,CBD.IntakeMasterID,
            CBD .Duration_Id as DurationID,      
            CBD .Batch_Id as ID,
            O.Organization_Name,                          
            CBD .Batch_Code as BatchCode,   
            Tbl_Department.Course_Code,
            convert(varchar(50),CBD .Batch_From,103) as Batch_From,             
            convert(varchar(50),CBD .Batch_To,103) as Batch_To,
            CBD .Study_Mode ,                 
            PD.Program_Duration_Type,                  
            PD.Program_Duration_Year,           
            PD.Program_Duration_Month ,  
            convert(varchar(50),CBD .Intro_Date,103) as Intro_Date,                
            CBD .SyllubusCode,      
            CD.Course_Category_Id,  Tbl_Department.Department_Name, Tbl_Department.Department_Id as programid,   
            CC.Course_Category_Name as CategoryName,CBD .SyllubusCode,  convert(varchar(50),CBD.Close_Date,103) as Close_Date  ,        
                 Tbl_Department. Department_Id,
                 Tbl_Department.Department_Id,Tbl_Department.Department_Name ,isnull (cbd.Intro_Date,''1900-01-01 00:00:00.000'') Intro_Datel,isnull (Close_Date,''1900-01-01 00:00:00.000'') Close_Date
                 --,isnull (Close_Date_inter,''1900-01-01 00:00:00.000'') closedateinter, isnull (Open_Date_inter,''1900-01-01 00:00:00.000'') interopen
,cbd.Org_Id,Tbl_Department.Course_Code as ProgramCode,
*
                         
        FROM dbo.Tbl_Course_Batch_Duration CBD              
            INNER JOIN Tbl_Organzations O on O.Organization_Id=CBD .Org_Id             
            INNER JOIN Tbl_Program_Duration PD on CBD .Duration_Id=PD.Program_Category_Id                             
            inner join  dbo.Tbl_Department on Tbl_Department.Department_Id=PD.Program_Category_Id               
            inner join dbo.Tbl_Course_Department CD on CD.Department_Id=Tbl_Department.Department_Id            
            inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id            
        WHERE Batch_DelStatus=0   and Tbl_Department.Department_Status = 0
        and(IntakeMasterID = @intakeMasterID or @intakeMasterID =0)                 
         --and Batch_Id in(select ProgramIntakeID from fee_group where Promotional=0 and deleteStatus=0 and active=1)                  
    and CBD.Org_id=@ord_id  
         Order by CBD.Batch_Id DESC   
end    ')
END
GO
