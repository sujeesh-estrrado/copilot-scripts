IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_StudentAttendace_For_DutyLeave]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_Update_StudentAttendace_For_DutyLeave]

(@Candidate_Id bigint,@Duration_Mapping_Id bigint,@Absent_Date datetime ,@Absent_Type varchar(150))




AS

BEGIN

    UPDATE dbo.Tbl_Student_Absence

        SET    
              
               Absent_Type              = @Absent_Type
              
              
        WHERE  Candidate_Id                 = @Candidate_Id and 
               Duration_Mapping_Id          =  @Duration_Mapping_Id and
              Absent_Date                = @Absent_Date 

END
    ')
END
