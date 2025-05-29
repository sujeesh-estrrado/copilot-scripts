IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SeatCapacity_GetAll_By_CategoryId_intake]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_SeatCapacity_GetAll_By_CategoryId_intake] --3           
 (@Course_Cat_Id VARCHAR(MAX))                  
                   
AS                  
BEGIN                  
             SET NOCOUNT ON;
             -- Declare variables to handle the string splitting
    DECLARE @Pos INT = 0;
    DECLARE @CategoryId INT;
    DECLARE @CourseCatList TABLE (Course_Cat_Id INT);

    -- If FacultyId is NULL or empty, return all active faculties
    IF @Course_Cat_Id IS NULL OR @Course_Cat_Id = ''''          
    
SELECT BD.Batch_Id,BD.Duration_Id as DurationID,intake_no,        
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
D.Department_Id  ,Concat(fORMAT( BD.Batch_From,''MMMM'') ,'' '',fORMAT( BD.Batch_From,''yyyy'')) as Batchname              
                    
                           
FROM dbo.Tbl_Course_Batch_Duration BD                           
INNER JOIN Tbl_Program_Duration PD on BD.Duration_Id=PD.Duration_Id                                
inner join  dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id                 
inner join dbo.Tbl_Course_Department CD on CD.Department_Id=D.Department_Id              
inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id              
WHERE Batch_DelStatus=0   and D.Department_Status = 0         
and  D.Department_Id =@Course_Cat_Id                    
                              
Order by BatchCode    desc;
END
BEGIN
 WHILE CHARINDEX('','', @Course_Cat_Id) > 0
        BEGIN
            SET @Pos = CHARINDEX('','', @Course_Cat_Id);
            SET @CategoryId = CAST(SUBSTRING(@Course_Cat_Id, 1, @Pos - 1) AS INT);
            INSERT INTO @CourseCatList (Course_Cat_Id) VALUES (@CategoryId);
            SET @Course_Cat_Id = SUBSTRING(@Course_Cat_Id, @Pos + 1, LEN(@Course_Cat_Id));
        END;

        -- Insert the last value after the final comma
        IF LEN(@Course_Cat_Id) > 0
            INSERT INTO @CourseCatList (Course_Cat_Id) VALUES (CAST(@Course_Cat_Id AS INT));

SELECT BD.Batch_Id,BD.Duration_Id as DurationID,intake_no,        
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
D.Department_Id  ,Concat(fORMAT( BD.Batch_From,''MMMM'') ,'' '',fORMAT( BD.Batch_From,''yyyy'')) as Batchname              
                    
                           
FROM dbo.Tbl_Course_Batch_Duration BD                           
INNER JOIN Tbl_Program_Duration PD on BD.Duration_Id=PD.Duration_Id                                
inner join  dbo.Tbl_Department D on D.Department_Id=PD.Program_Category_Id                 
inner join dbo.Tbl_Course_Department CD on CD.Department_Id=D.Department_Id              
inner join dbo.Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id              
WHERE Batch_DelStatus=0   and D.Department_Status = 0         
and  D.Department_Id IN (SELECT Course_Cat_Id FROM @CourseCatList)                 
                              
Order by BatchCode    desc ; 


         
         
         
END 

');
END;