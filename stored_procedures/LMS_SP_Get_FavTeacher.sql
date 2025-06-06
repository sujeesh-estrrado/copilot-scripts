IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_FavTeacher]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Get_FavTeacher] --446                  
@Candidate_Id bigint               
                                  
AS                                                                  
BEGIN                     
Declare @DurationMapping_Id bigint             
set @DurationMapping_Id=(select distinct Duration_Mapping_Id from Tbl_Student_Semester             
where Student_Semester_Delete_Status=0 and Student_Semester_Current_Status=1              
and Candidate_Id=@Candidate_Id)               
            
select Teacher_Id from LMS_Tbl_FavouriteTeacher  where Student_Id=@Candidate_Id and  Duration_Mapping_Id=@DurationMapping_Id    
           
END
    ')
END
