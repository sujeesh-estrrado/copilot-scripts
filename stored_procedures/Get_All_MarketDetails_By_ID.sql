IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_MarketDetails_By_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Get_All_MarketDetails_By_ID]        
(@marketingid bigint)            
As            
Begin            
select * from  dbo.Tbl_Marketing   where Marketing_Id =@marketingid  
select distinct(tm.Target_MarketID) Market_Id,tm.Target_MarketType Market_Target from dbo.Tbl_Target_Market tm inner join dbo.Tbl_Marketing_TargetMap mtm on tm.Target_MarketID=mtm.Target_MarketID where mtm.Marketing_Id=@marketingid    
select distinct (gc.GroupCourseCodeId),gc.GroupCourseCode from Tbl_Group_Course gc  inner join dbo.Tbl_Marketing_ContentMap Mc on Mc.GroupCourseCodeId=gc.GroupCourseCodeId where Mc.Marketing_Id=@marketingid    
select distinct(m.Measurement_Id),m.Media_Code,m.Height,m.Width  from dbo.Tbl_Measurement m inner join dbo.Tbl_Marketing_MeasurementMap mm on m.Measurement_Id=mm.Measurement_Id where mm.Marketing_Id =@marketingid    
select Show_date,Datenow[Date],Details,M_Cur_code,M_Amt,C_Cur_Code,C_Amt,Acc_Code,Acc_Amt,Statuss [Status],mc.Id from dbo.Tbl_MediaCosting mc inner join dbo.tblMediaCostMap mcm on mcm.MediaCostId=mc.Id where mcm.Marketing_Id=@marketingid   
select Nationality_Id, Nationality from Tbl_Nationality N inner join dbo.MarketCountryMap CM on cm.countryId=N.Nationality_Id where cm.marketId=@marketingid    
end
    ')
END;
