IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Student_Mandatory_Cert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Student_Mandatory_Cert]                
(@Batch_Id bigint,    
@Class_Id bigint,                
@Student_Id bigint,    
@Certificate_Name varchar(200),                
@Date datetime,    
@Submitted bit,
@Certificate_Img varchar(max),        
@Del_Status bit)                
                 
AS                    
--IF EXISTS(Select Student_Id from dbo.Tbl_Student_Mandatory_Certificate where Student_Id=@Student_Id and Certificate_Id=@Certificate_Id and Del_Status=0)           
--BEGIN             
--RAISERROR(''Certificate already exists for the student'', 16,1);                
--END          
--ELSE          
BEGIN               
INSERT INTO dbo.Tbl_Student_Mandatory_Certificate(Batch_Id,Class_Id,Student_Id,Certificate_Name,Date,Submitted,Certificate_Img,Del_Status)                
VALUES                
(@Batch_Id,@Class_Id,@Student_Id,@Certificate_Name,@Date,@Submitted,@Certificate_Img,@Del_Status)                
                
select Scope_identity()                
                    
END
    ')
END;
