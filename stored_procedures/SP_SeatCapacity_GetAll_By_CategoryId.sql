IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SeatCapacity_GetAll_By_CategoryId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_SeatCapacity_GetAll_By_CategoryId] --3           
 (@Course_Cat_Id BIGINT)                  
                   
AS                  
BEGIN                  
                            
SELECT BD.Batch_Id,BD.Duration_Id as DurationID,
ISNULL(BD.intake_no,BD.Batch_Code)as intake_no,         
BD.Batch_Id as ID,                              
BD.Batch_Code as BatchCode,                              
BD.Batch_From,BD.Batch_To,                       
 BD.Study_Mode ,                     
PD.Program_Duration_Type,                    
PD.Program_Duration_Year,             
PD.Program_Duration_Month ,               
BD.Intro_Date,                  
BD.SyllubusCode,        
CD.Course_Category_Id,        
CC.Course_Category_Name as CategoryName,        
D.Department_Id  ,Concat(fORMAT( BD.Batch_From,''MMMM'') ,'' '',
fORMAT( BD.Batch_From,''yyyy'')) as Batchname              
                    
                           
FROM dbo.Tbl_Course_Batch_Duration BD                           
INNER JOIN Tbl_Program_Duration PD on BD.Duration_Id=PD.Duration_Id                                
inner join  dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id                 
inner join dbo.Tbl_Course_Department CD on CD.Department_Id=D.Department_Id              
inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id              
WHERE Batch_DelStatus=0   and D.Department_Status = 0         
and  D.Department_Id =@Course_Cat_Id                    
                              
Order by BatchCode    desc      
         
         
         
END 
');
END;