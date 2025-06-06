IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_CourseBatchDuration_new]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Update_CourseBatchDuration_new]
(@Org_Id bigint,@Duration_Id bigint,@Batch_Code varchar(100),      
@Batch_From datetime,@Batch_To datetime,@Batch_Id bigint,@StudyMode varchar(50),@EntryDate datetime,
@Syllubuscode varchar(50),@CloseDate datetime,@Regdate datetime='''',@CloseDateinter      datetime ='''',@OpenDateinter datetime ='''',@IntakeMasterID BIGINT = 0)       
AS     
    
--IF  EXISTS (SELECT Duration_Id FROM Tbl_Course_Batch_Duration WHERE Duration_Id=@Duration_Id and Batch_DelStatus=0 and Batch_Code=@Batch_Code  and Batch_Id <> @Batch_Id  )    
--BEGIN          
--  RAISERROR (''Data Already exists.'', -- Message text.          
--               16, -- Severity.          
--               1 -- State.          
--               );          
--END          
--ELSE       
     
BEGIN
UPDATE Tbl_Course_Batch_Duration      
SET 
Org_Id=@Org_Id,      
--Duration_Id=@Duration_Id,      
Batch_Code=@Batch_Code,      
Batch_From=@Batch_From,      
Batch_To=@Batch_To ,  
Study_Mode  =@StudyMode ,
Intro_Date  =@EntryDate,
SyllubusCode =@Syllubuscode,
Close_Date=@CloseDate,
dateregsatart = @Regdate 
WHERE Batch_Id=@Batch_Id  

UPDATE Tbl_IntakeMaster
SET 
dateregsatart = (SELECT MIN(CONVERT(VARCHAR,Intro_Date,23)) FROM Tbl_Course_Batch_Duration WHERE IntakeMasterID=@IntakeMasterID),
--Batch_From = (SELECT MIN(Intro_Date) FROM Tbl_Course_Batch_Duration WHERE IntakeMasterID=@IntakeMasterID),
--Batch_To = @Batch_To,
--Study_Mode = @StudyMode,
Intro_Date = (SELECT MIN(Intro_Date) FROM Tbl_Course_Batch_Duration WHERE IntakeMasterID=@IntakeMasterID),
Close_Date = (SELECT MAX(Close_Date) FROM Tbl_Course_Batch_Duration WHERE IntakeMasterID=@IntakeMasterID)
WHERE Batch_Code = @Batch_Code AND id = @IntakeMasterID
END

    ')
END
