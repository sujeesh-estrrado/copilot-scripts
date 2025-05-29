IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertUpdate_Candidate_AirportPickup]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_InsertUpdate_Candidate_AirportPickup]
(@Candidate_Id bigint,
@AirportPickup_Status bit,
@Employee_Id bigint
)

as
begin
if exists(select * from Tbl_Candidate_AirportPickup where Candidate_Id=@Candidate_Id and Delete_Status=0)
begin
update Tbl_Candidate_AirportPickup set 
AirportPickup_Status=@AirportPickup_Status,
Employee_Id=@Employee_Id,Updated_Date=getdate() where Candidate_Id=@Candidate_Id;
end
else
begin
Insert into Tbl_Candidate_AirportPickup(Candidate_Id,AirportPickup_Status,Employee_Id,Created_Date,Delete_Status)
values(@Candidate_Id,@AirportPickup_Status,@Employee_Id,getdate(),0)
end
end ');
END;
