IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetTrainingDetails_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetTrainingDetails_By_Employee_Id]   
@StudentOrEmployee_Id bigint  
AS  
BEGIN  
SELECT   
Distinct   
TA.Training_Id,  
Topic,  
Conducted_By,  
Date  
FROM Tbl_Training_Pgm TP INNER JOIN Tbl_Training_Attendees TA  
ON TP.Training_Id=TA.Training_Id  
WHERE StudentOrEmployee_Id=@StudentOrEmployee_Id and StudentOrEmployee=1  
END

   ')
END;
