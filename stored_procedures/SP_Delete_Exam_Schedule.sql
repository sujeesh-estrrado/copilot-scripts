IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Exam_Schedule]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Delete_Exam_Schedule]                    
( 
@Exam_Schedule_Id bigint
)                    
                    
AS                    

BEGIN                     
                    
Update Tbl_Exam_Schedule          
Set Exam_Schedule_Status=1 Where Exam_Schedule_Id=@Exam_Schedule_Id
END
    ')
END
