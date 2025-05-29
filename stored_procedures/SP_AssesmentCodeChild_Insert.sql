IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_AssesmentCodeChild_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_AssesmentCodeChild_Insert] (                    
@Assessment_Type_Id  bigint,                      
@Assessment_Perc decimal,                      
@GivenMarks decimal,                      
@Passing_Marks decimal,      
@Allowance decimal,    
--@Grading_Scheme  varchar(250),  
@Last bit,  
@AssesmentTypeCode varchar(50),  
@Assessment_Code_Id bigint)             
AS                      
BEGIN                       
insert into dbo.Tbl_Assessment_Code_Child (Assessment_Code_Id,Assessment_Type_Id,Assessment_Perc,GivenMarks,Passing_Marks,Allowance,[Last],AssesmentTypeCode)            
values(@Assessment_Code_Id,@Assessment_Type_Id,@Assessment_Perc,@GivenMarks,@Passing_Marks,@Allowance,@Last,@AssesmentTypeCode)            
 select Scope_identity()          
END

    ')
END;
