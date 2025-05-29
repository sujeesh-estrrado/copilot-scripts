IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_StudentAttendance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_StudentAttendance]      
(      
@Candidate_Id bigint,       
@Absent_Date  datetime,      
@Duration_Mapping_Id bigint ,
@Class_Timings_Id bigint,
@Absent_Type varchar(150) 
)      
AS      
BEGIN      
      
        
 INSERT INTO  Tbl_Student_Absence      
             (Candidate_Id,Duration_Mapping_Id,Absent_Date,Class_Timings_Id,Absent_Type)        
     VALUES        
           (@Candidate_Id,@Duration_Mapping_Id,@Absent_Date,@Class_Timings_Id,@Absent_Type)        
      
      
END
    ');
END;
