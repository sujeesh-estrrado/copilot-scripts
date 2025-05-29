IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_Function_GetEmployeeSubWiseRating]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('

CREATE FUNCTION [dbo].[LMS_Function_GetEmployeeSubWiseRating]   
(    
 -- Add the parameters for the function here    
 @Teacher_Id bigint,    
    @Semester_Subject_Id bigint    
)    
RETURNS bigint    
AS    
BEGIN    
 -- Declare the return variable here    
 DECLARE @Rating bigint    
    
    
 DECLARE @Count1 bigint    
 DECLARE @Count2 bigint    
 DECLARE @Count3 bigint    
 DECLARE @Count4 bigint    
 DECLARE @Count5 bigint    
    
     
set @Count1=(select count(TeacherRating_Id) from dbo.LMS_Tbl_SubWiseTeacherRating     
where Status=0 and Teacher_Id=@Teacher_Id and Semester_Subject_Id=@Semester_Subject_Id and CountofStars=1)    
set @Count2=(select count(TeacherRating_Id) from dbo.LMS_Tbl_SubWiseTeacherRating     
where Status=0 and Teacher_Id=@Teacher_Id and Semester_Subject_Id=@Semester_Subject_Id and CountofStars=2)    
set @Count3=(select count(TeacherRating_Id) from dbo.LMS_Tbl_SubWiseTeacherRating     
where Status=0 and Teacher_Id=@Teacher_Id and Semester_Subject_Id=@Semester_Subject_Id and CountofStars=3)    
set @Count4=(select count(TeacherRating_Id) from dbo.LMS_Tbl_SubWiseTeacherRating     
where Status=0 and Teacher_Id=@Teacher_Id and Semester_Subject_Id=@Semester_Subject_Id and CountofStars=4)    
set @Count5=(select count(TeacherRating_Id) from dbo.LMS_Tbl_SubWiseTeacherRating     
where Status=0 and Teacher_Id=@Teacher_Id and Semester_Subject_Id=@Semester_Subject_Id and CountofStars=5)    
  
  if(@Count1+@Count2+@Count3+@Count4+@Count5>0)  
  
set @Rating=ROUND(((@Count1*1+@Count2*2+@Count3*3+@Count4*4+@Count5*5)/(@Count1+@Count2+@Count3+@Count4+@Count5)),0)   
  
else  
  
set @Rating=0  
  
    
  
 -- Return the result of the function    
 RETURN @Rating    
END

    ')
END
