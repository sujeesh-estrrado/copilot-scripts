IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_IntakeMaster]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_IntakeMaster] 
(
@flag bigint =0,
@id	bigint =0,
@Org_Id	varchar(MAX) ='''',
@IntakeID bigint=0,
@IntakeMaster	bigint =0,
@intake_no	varchar(50) ='''',
@intake_month	varchar(50) ='''',
@intake_year	varchar(50) ='''',
@localdepo	varchar(50) ='''',
@interdepo	varchar(50) ='''',
@dateregsatart	date =NULL,
@dateregend	date =NULL,
@timestart	time(7) =NULL,
@timeend	time(7) =NULL,
@venue	varchar(500) ='''',
@lastnumber	varchar(50) ='''',
@created_by	bigint =0,
@Batch_Code	varchar(100) ='''',
@Batch_From	datetime =NULL,
@Batch_To	datetime =NULL,
@StudyMode	varchar(50) ='''',
@EntryDate	datetime =NULL,
@CloseDate	datetime =NULL,
@SyllubusCode	varchar(50) ='''',
@create_date	datetime =NULL,
@updated_by	bigint =0,
@updated_date	datetime =NULL,
@Regdate date =NULL,
@Duration_Id bigint =0,
@IntakeMasterID bigint=0 output,
@CloseDateinter	datetime =NULL,
@Mode varchar(100)='''',
@OpenDateinter datetime =NULL,
@ReturnDate datetime=NULL,
@CommenceDate datetime=NULL,
@AdmitTerm varchar(4)=''''


)
as
begin
	if(@flag=1)
	begin
		IF  EXISTS (SELECT id FROM Tbl_IntakeMaster WHERE Org_Id=@Org_Id and DeleteStatus=0 
					 and Batch_Code= @Batch_Code --and Org_Id=@Org_Id --or( intake_month = @intake_month and intake_year = @intake_year and Org_Id =@Org_Id)
					 )          
		BEGIN          
		  RAISERROR (''Data Already exists.'', -- Message text.          
					   16, -- Severity.          
					   1 -- State.          
					   );          
		END          
		ELSE   
		BEGIN  
			INSERT INTO [dbo].[Tbl_IntakeMaster]
			   ([Org_Id],[intake_no],[intake_month],[intake_year],[localdepo],[interdepo],[dateregsatart],[dateregend],[timestart]
			   ,[timeend],[venue],[lastnumber],[created_by],[Batch_Code],[Batch_From],[Batch_To],[Batch_DelStatus],[Study_Mode],[Intro_Date]
			   ,[Close_Date],[SyllubusCode],[create_date],[updated_by],[updated_date],DeleteStatus)
			 VALUES
				   (@Org_Id,@intake_no,@intake_month,@intake_year,@localdepo,@interdepo,@dateregsatart,@dateregend,@timestart,@timeend,
				   @venue,0,@created_by,@Batch_Code,@Batch_From,@Batch_To,0,@StudyMode,@EntryDate,@CloseDate,
					@SyllubusCode,@create_date,@updated_by,@updated_date,0)

				SET @IntakeMasterID=SCOPE_IDENTITY()
					select  @IntakeMasterID as IntakeMasterID
		end
	end
	if(@flag=2)
	begin
	SELECT        IM.id, IM.Org_Id, IM.intake_no, IM.intake_month, IM.intake_year, IM.localdepo, IM.interdepo, IM.dateregsatart, IM.dateregend, IM.timestart, IM.timeend, IM.venue, IM.lastnumber, IM.created_by, IM.Batch_Code, IM.Batch_From, 
                         IM.Batch_To, IM.Batch_DelStatus, IM.Study_Mode, IM.Intro_Date, IM.Close_Date, IM.SyllubusCode, IM.create_date, IM.updated_by, IM.updated_date, IM.DeleteStatus,
						  CONCAT(IM.intake_year, ''/'', IM.intake_month)AS IntakeMonth, Org.Organization_Name
	FROM            dbo.Tbl_IntakeMaster AS IM INNER JOIN
							 dbo.[Tbl_Organzations ] AS Org ON IM.Org_Id = Org.Organization_Id
	WHERE        (IM.id = @id or @id  = 0) AND (IM.DeleteStatus = 0)
	order by IM.Batch_Code desc
	
	end
	if(@flag=3)--Check Existance
	begin
		SELECT * FROM [dbo].[Tbl_IntakeMaster]
		where (Batch_Code like  ''%''+@Batch_Code+''%'') and Org_Id = @Org_Id and [DeleteStatus] = 0
	end
	if(@flag=4)--Delete Intake Master
	begin
		if exists (SELECT * FROM dbo.Tbl_Candidate_Personal_Det AS CPD INNER JOIN
								dbo.tbl_New_Admission AS NA ON CPD.New_Admission_Id = NA.New_Admission_Id INNER JOIN
								dbo.Tbl_Course_Batch_Duration AS CBD ON NA.Batch_Id = CBD.Batch_Id
					WHERE       (CPD.Candidate_DelStatus = 0) and CBD.IntakeMasterID =  @id)
		BEGIN          
			RAISERROR (''Reference Exists '', -- Message text.          
					   16, -- Severity.          
					   1 -- State.          
					   );          
		END          
		ELSE   
		BEGIN  
			update [Tbl_IntakeMaster] set DeleteStatus = 1 where id = @id
		end 
	end
	if(@flag=5)--Update Intake Master
	begin
		if exists (SELECT * FROM dbo.Tbl_Candidate_Personal_Det AS CPD INNER JOIN
								dbo.tbl_New_Admission AS NA ON CPD.New_Admission_Id = NA.New_Admission_Id INNER JOIN
								dbo.Tbl_Course_Batch_Duration AS CBD ON NA.Batch_Id = CBD.Batch_Id
					WHERE       (CPD.Candidate_DelStatus = 0) and CBD.IntakeMasterID =  @id)
		BEGIN          
			RAISERROR (''Reference Exists '', -- Message text.          
					   16, -- Severity.          
					   1 -- State.          
					   );          
		END          
		ELSE   
		BEGIN 
			UPDATE [dbo].[Tbl_IntakeMaster]
			SET [Org_Id] = @Org_Id,[intake_no] = @Batch_Code,[intake_month] = @intake_month,[intake_year] = @intake_year, [localdepo] = @localdepo,
				[interdepo] = @interdepo,[dateregsatart] = @dateregsatart,[dateregend] = @dateregend,[timestart] =@timestart,[timeend] = @timeend,
				[venue] =@venue,[Batch_Code] = @Batch_Code,[Batch_From] = @Batch_From,[Batch_To] = @Batch_To,[Batch_DelStatus] = 0 ,
				[Study_Mode] = @StudyMode,[Intro_Date] = @EntryDate,[Close_Date] = @CloseDate,[SyllubusCode] = @SyllubusCode,[updated_by] = @updated_by,[updated_date] =getdate()
		--,[lastnumber] = @lastnumber
			 WHERE id = @IntakeMaster
		 end
	end

	if(@flag=6)--Delete IntakePrograms by IntakeMasterID
	begin
		update Tbl_Course_Batch_Duration set Batch_DelStatus = 1 where IntakeMasterID = @IntakeMaster 
	end 
	if(@flag=7)--get  IntakePrograms by IntakeMasterID and Program
	begin
		select  Batch_Id from Tbl_Course_Batch_Duration where IntakeMasterID = @IntakeMaster and Duration_Id = @Duration_Id and Batch_DelStatus = 0
	end 
	if(@flag=8)--Add IntakePrograms by IntakeMasterID and Program if deleted
	begin
		UPDATE Tbl_Course_Batch_Duration      
		SET 
		Org_Id=@Org_Id,      
		--Duration_Id=@Duration_Id,      
		Batch_Code=@Batch_Code,      
		Batch_From=@Batch_From,      
		Batch_To=@Batch_To ,  
		Study_Mode  =@StudyMode ,
		Intro_Date  =@EntryDate,
		Close_Date=@CloseDate,
		dateregsatart = @Regdate   
		where Batch_Id = @IntakeID
		--IntakeMasterID = @IntakeMaster and Duration_Id = @Duration_Id and Batch_DelStatus = 1

		--update Tbl_Course_Batch_Duration set Batch_DelStatus = 0 where IntakeMasterID = @IntakeMaster and Duration_Id = @Duration_Id and Batch_DelStatus = 1
	end 
	if(@flag=9)--No of Appications in IntakeMaster
	begin
		SELECT COUNT(CPD.Candidate_Id) AS Enquries
		FROM            dbo.Tbl_Candidate_Personal_Det AS CPD INNER JOIN
											 dbo.tbl_New_Admission AS NA ON CPD.New_Admission_Id = NA.New_Admission_Id INNER JOIN
											 dbo.Tbl_Course_Batch_Duration AS CBD ON NA.Batch_Id = CBD.Batch_Id
		WHERE        (CPD.Candidate_DelStatus = 0) and CBD.IntakeMasterID =  @IntakeMaster
	end
	if(@flag=10)--Get MasterIntakes other that this(@IntakeMaster)
	begin
	SELECT        IM.id, IM.Org_Id,IM.Batch_Code as intake_no, IM.intake_month, IM.intake_year, IM.localdepo, IM.interdepo, IM.dateregsatart, IM.dateregend, IM.timestart, IM.timeend, IM.venue, IM.lastnumber, IM.created_by, IM.Batch_Code, IM.Batch_From, 
                         IM.Batch_To, IM.Batch_DelStatus, IM.Study_Mode, IM.Intro_Date, IM.Close_Date, IM.SyllubusCode, IM.create_date, IM.updated_by, IM.updated_date, IM.DeleteStatus,
						  CONCAT(IM.intake_year, ''/'', IM.intake_month)AS IntakeMonth, Org.Organization_Name
	FROM            dbo.Tbl_IntakeMaster AS IM INNER JOIN
							 dbo.[Tbl_Organzations ] AS Org ON IM.Org_Id = Org.Organization_Id
	WHERE        (IM.id <>@IntakeMaster) AND (IM.DeleteStatus = 0)
	order by IM.Batch_Code desc
	
	end
end
');
END;