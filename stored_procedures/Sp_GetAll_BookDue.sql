IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_BatchId]')
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_GetAll_BatchId] --9        
  (
  @flag bigint=0,
   @studymode varchar(2)='''',
  @campus varchar(1)='''',
  @pgmID bigint = 0
  )            
AS              
BEGIN              
  
  if(@flag=0)
  begin                      
--SELECT BD.Batch_Id,BD.Duration_Id as DurationID,    
--BD.Batch_Id as ID,                          
--BD.Batch_Code as BatchCode,                          
--BD.Batch_From,BD.Batch_To,                                         
--BD.Study_Mode ,                                    
--PD.Program_Duration_Type,                
--PD.Program_Duration_Year,         
--PD.Program_Duration_Month ,           
--BD.Intro_Date,              
--BD.SyllubusCode 
--FROM dbo.Tbl_Course_Batch_Duration BD                       
--INNER JOIN Tbl_Program_Duration PD on BD.Duration_Id=PD.Duration_Id                  
--inner join  dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id                 
--WHERE Batch_DelStatus=0   
                         
--Order by BatchCode      
SELECT id as Batch_Id ,Batch_Code as BatchCode, 
 Batch_Code as OrgName 
 --concat(Batch_Code+'' - '',(select Organization_Name from [Tbl_Organzations ] t where t.Organization_Id=IM.Org_Id )+'' - ''+IM.Study_Mode) as OrgName 
FROM Tbl_IntakeMaster IM where DeleteStatus=0 and Batch_Code!='''' order by BatchCode desc   
  end 

    if(@flag=1)
  begin                      
 SELECT id as Batch_Id ,
 Batch_Code as BatchCode, 
 Batch_Code as OrgName 
 --concat(Batch_Code+'' - '',(select Organization_Name from [Tbl_Organzations ] t where t.Organization_Id=IM.Org_Id )+'' - ''+IM.Study_Mode) as OrgName 
FROM Tbl_IntakeMaster IM 
where DeleteStatus=0 and Batch_Code!='''' order by BatchCode desc            
   
  end 
    
    if(@flag=3)
  begin                      
SELECT 
BD.Batch_Id  as Batch_Id ,           
BD.Batch_Code as BatchCode ,
BD.Batch_Code as OrgName
                           
FROM dbo.Tbl_Course_Batch_Duration BD                           
INNER JOIN Tbl_Program_Duration PD on BD.Duration_Id=PD.Duration_Id                                
inner join  dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id              
WHERE Batch_DelStatus=0   and D.Department_Status = 0  
and  D.Department_Id = @pgmID
   
  end 
   if(@flag=4)
  begin 
SELECT 
    Batch_Code,
    STRING_AGG(CAST(Batch_Id AS VARCHAR), '', '') AS Batch_Ids
FROM Tbl_Course_Batch_Duration
WHERE Batch_DelStatus = 0
GROUP BY Batch_Code
ORDER BY Batch_Code;  end
END
    ')
END
GO