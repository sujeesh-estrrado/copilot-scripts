IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[insertgroupcoursetemp]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[insertgroupcoursetemp](@GroupCourseCodeId int,  
@GroupCourseCode varchar(50),  
@GroupCourseName varchar(50),  
@GroupCourseDescription varchar(50),  
@MajorCode varchar(50),  
@Awards varchar(50),  
@ProgramCodeId int,  
@ProviderCodeId int,  
@GraduationTypeId int,  
@ReqCreditHours varchar(50),  
@Qualification varchar (50))  
as  
begin  
insert into groupcoursetemp values(@GroupCourseCodeId,
@GroupCourseCode,  
@GroupCourseName,  
@GroupCourseDescription,  
@MajorCode,  
@Awards,  
@ProgramCodeId,  
@ProviderCodeId,  
@GraduationTypeId,  
@ReqCreditHours,  
@Qualification)  
SELECT SCOPE_IDENTITY()   
end
    ')
END
