USE [SHO]
GO
/****** Object:  UserDefinedDataType [dbo].[shoACCOUNT]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE TYPE [dbo].[shoACCOUNT] FROM [nvarchar](20) NOT NULL
GO
/****** Object:  UserDefinedDataType [dbo].[shoCharNAME]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE TYPE [dbo].[shoCharNAME] FROM [nvarchar](30) NOT NULL
GO
/****** Object:  UserDefinedFunction [dbo].[fn_hexstring]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_hexstring] (@binvalue varbinary(8000), @prefix int) returns varchar(8000)
AS
begin
DECLARE @charvalue varchar(8000)
DECLARE @i int
DECLARE @length int
DECLARE @hexstring char(16)
if @prefix=0
begin
SELECT @charvalue = ''
end
if @prefix>0
begin
	SELECT @charvalue = '0x'
end
SELECT @i = 1
SELECT @length = DATALENGTH (@binvalue)
SELECT @hexstring = '0123456789ABCDEF' 
WHILE (@i <= @length) 
BEGIN
  DECLARE @tempint int
  DECLARE @firstint int
  DECLARE @secondint int
  SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1))
  SELECT @firstint = FLOOR(@tempint/16)
  SELECT @secondint = @tempint - (@firstint*16)
  SELECT @charvalue = @charvalue +
    SUBSTRING(@hexstring, @firstint+1, 1) +
    SUBSTRING(@hexstring, @secondint+1, 1)
  SELECT @i = @i + 1
END
return(@charvalue)
end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_showbankzully]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_showbankzully](@binvalue varbinary(8000)) returns varchar(10)
AS
begin
DECLARE @charvalue varchar(8000)
DECLARE @hexbit varchar(10)
DECLARE @zully int
DECLARE @i int
DECLARE @length int
DECLARE @hexstring char(16)
SELECT @charvalue = ''
SELECT @i = 1
SELECT @length = DATALENGTH (@binvalue)
SELECT @hexstring = '0123456789ABCDEF' 
WHILE (@i <= @length) 
BEGIN
  DECLARE @tempint int
  DECLARE @firstint int
  DECLARE @secondint int
  SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1))
  SELECT @firstint = FLOOR(@tempint/16)
  SELECT @secondint = @tempint - (@firstint*16)
  SELECT @charvalue = @charvalue +
    SUBSTRING(@hexstring, @firstint+1, 1) +
    SUBSTRING(@hexstring, @secondint+1, 1)
  SELECT @i = @i + 1
END
set @hexbit=reverse(substring(reverse((@charvalue)),15,10))
set @hexbit=(substring(@hexbit,9,2)+substring(@hexbit,7,2)+substring(@hexbit,5,2)+substring(@hexbit,3,2)+substring(@hexbit,1,2))

if substring(@hexbit,9,2)='00'
begin
	set @hexbit=substring(@hexbit,1,8)
end
if substring(@hexbit,7,2)='00'
begin
	set @hexbit=substring(@hexbit,1,6)
end

return(@hexbit)
end

GO
/****** Object:  UserDefinedFunction [dbo].[ufn_VarbinaryToVarcharHex]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ufn_VarbinaryToVarcharHex] (@VarbinaryValue varbinary(4000))
RETURNS Varchar(8000) AS
BEGIN

Declare @NumberOfBytes Int
Declare @LeftByte Int
Declare @RightByte Int

SET @NumberOfBytes = datalength(@VarbinaryValue)

IF (@NumberOfBytes > 4)
RETURN SHO.dbo.ufn_VarbinaryToVarcharHex(cast(substring(@VarbinaryValue,

1,

(@NumberOfBytes/2)) as varbinary(2000)))
+ SHO.dbo.ufn_VarbinaryToVarcharHex(cast(substring(@VarbinaryValue,

((@NumberOfBytes/2)+1),

2000) as varbinary(2000)))

IF (@NumberOfBytes = 0)
RETURN ''


-- Either 4 or less characters (8 hex digits) were input
SET @LeftByte = CAST(@VarbinaryValue as Int) & 15
SET @LeftByte = CASE WHEN (@LeftByte < 10)
THEN (48 + @LeftByte)
ELSE (87 + @LeftByte)
END
SET @RightByte = (CAST(@VarbinaryValue as Int) / 16) & 15
SET @RightByte = CASE WHEN (@RightByte < 10)
THEN (48 + @RightByte)
ELSE (87 + @RightByte)
END
SET @VarbinaryValue = SUBSTRING(@VarbinaryValue, 1,
(@NumberOfBytes-1))

RETURN CASE WHEN (@LeftByte < 10)
THEN
SHO.dbo.ufn_VarbinaryToVarcharHex(@VarbinaryValue) +
char(@RightByte) + char(@LeftByte)
ELSE
SHO.dbo.ufn_VarbinaryToVarcharHex(@VarbinaryValue) +
char(@RightByte) + char(@LeftByte)
END


END

GO
/****** Object:  Table [dbo].[InventorySweep]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventorySweep](
	[CharName] [varchar](60) NOT NULL,
	[ItemID] [varchar](7) NOT NULL,
	[ItemStats] [varchar](50) NULL,
	[ItemCount] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblGS_AVATAR]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGS_AVATAR](
	[intCharID] [int] IDENTITY(1,1) NOT NULL,
	[txtACCOUNT] [nvarchar](20) NOT NULL,
	[txtNAME] [nvarchar](30) NOT NULL,
	[btLEVEL] [smallint] NULL,
	[intMoney] [bigint] NULL,
	[dwRIGHT] [int] NULL,
	[binBasicE] [binary](96) NOT NULL,
	[binBasicI] [binary](32) NOT NULL,
	[binBasicA] [binary](48) NOT NULL,
	[binGrowA] [binary](384) NOT NULL,
	[binSkillA] [binary](384) NOT NULL,
	[blobQUEST] [binary](1024) NULL,
	[blobINV] [binary](2048) NOT NULL,
	[binHotICON] [binary](64) NULL,
	[dwDelTIME] [int] NULL,
	[binWishLIST] [binary](256) NULL,
	[dwOPTION] [int] NULL,
	[intJOB] [smallint] NOT NULL,
	[dwRegTIME] [int] NOT NULL,
	[dwPartyIDX] [int] NULL,
	[dwItemSN] [int] NULL,
	[intDataVER] [smallint] NOT NULL,
	[txtCharName] [nvarchar](30) NULL,
	[binSkillB] [binary](240) NULL,
 CONSTRAINT [PK_tblGS_AVATAR] PRIMARY KEY CLUSTERED 
(
	[txtNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblGS_BANK]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGS_BANK](
	[txtACCOUNT] [nvarchar](20) NOT NULL,
	[blobITEMS] [binary](2250) NULL,
	[intREWARD] [money] NULL,
	[txtPASSWORD] [nvarchar](10) NULL,
 CONSTRAINT [PK_tblGS_BANK] PRIMARY KEY CLUSTERED 
(
	[txtACCOUNT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWS_CLAN]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWS_CLAN](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[txtNAME] [nchar](20) NOT NULL,
	[txtDESC] [nchar](255) NULL,
	[intMarkIDX1] [smallint] NOT NULL,
	[intMarkIDX2] [smallint] NULL,
	[intLEVEL] [smallint] NULL,
	[intPOINT] [int] NULL,
	[intAlliedID] [int] NULL,
	[intRATE] [smallint] NULL,
	[intMoney] [bigint] NULL,
	[binDATA] [binary](1024) NULL,
	[txtMSG] [nvarchar](368) NULL,
	[intMarkCRC] [smallint] NULL,
	[intMarkLEN] [smallint] NULL,
	[binMark] [binary](1024) NULL,
	[dateMarkREG] [datetime] NULL,
 CONSTRAINT [PK_tbl_WSCLAN] PRIMARY KEY CLUSTERED 
(
	[intID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWS_ClanCHAR]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWS_ClanCHAR](
	[txtCharNAME] [nchar](30) NOT NULL,
	[intClanID] [int] NOT NULL,
	[intPOINT] [int] NULL,
	[intPOS] [int] NULL,
 CONSTRAINT [PK_tblWS_ClanCHAR] PRIMARY KEY CLUSTERED 
(
	[txtCharNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWS_FRIEND]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWS_FRIEND](
	[intCharID] [int] NOT NULL,
	[intFriendCNT] [smallint] NOT NULL,
	[blobFRIENDS] [binary](1024) NULL,
 CONSTRAINT [PK_tblWS_FRIEND] PRIMARY KEY CLUSTERED 
(
	[intCharID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWS_MEMO]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWS_MEMO](
	[intSN] [bigint] IDENTITY(1,1) NOT NULL,
	[dwDATE] [int] NOT NULL,
	[txtNAME] [nvarchar](30) NOT NULL,
	[txtFROM] [nvarchar](30) NOT NULL,
	[txtMEMO] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_tblWS_MEMO] PRIMARY KEY CLUSTERED 
(
	[intSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWS_VAR]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWS_VAR](
	[txtNAME] [nvarchar](70) NOT NULL,
	[dateUPDATE] [datetime] NOT NULL,
	[binDATA] [varbinary](1024) NOT NULL,
 CONSTRAINT [PK_tblWS_VAR] PRIMARY KEY CLUSTERED 
(
	[txtNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usp]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usp](
	[li] [char](2000) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WarehouseSweep]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WarehouseSweep](
	[AccountName] [varchar](100) NULL,
	[ItemID] [varchar](7) NULL,
	[ItemStats] [varchar](50) NULL,
	[ItemCount] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WS_CheatLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WS_CheatLog](
	[Index] [int] NULL,
	[dateREG] [datetime] NULL,
	[Account] [nvarchar](20) NULL,
	[CharName] [nvarchar](30) NULL,
	[ChannelNo] [char](1) NULL,
	[CheatCode] [nvarchar](55) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tblGS_AVATAR]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_tblGS_AVATAR] ON [dbo].[tblGS_AVATAR]
(
	[txtACCOUNT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblGS_AVATAR_1]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_tblGS_AVATAR_1] ON [dbo].[tblGS_AVATAR]
(
	[intCharID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblGS_AVATAR_2]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_tblGS_AVATAR_2] ON [dbo].[tblGS_AVATAR]
(
	[btLEVEL] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblGS_AVATAR_3]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_tblGS_AVATAR_3] ON [dbo].[tblGS_AVATAR]
(
	[intMoney] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblGS_AVATAR_4]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_tblGS_AVATAR_4] ON [dbo].[tblGS_AVATAR]
(
	[intJOB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tblWS_CLAN]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_tblWS_CLAN] ON [dbo].[tblWS_CLAN]
(
	[txtNAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblWS_ClanCHAR]    Script Date: 5/9/2018 10:07:20 AM ******/
CREATE NONCLUSTERED INDEX [IX_tblWS_ClanCHAR] ON [dbo].[tblWS_ClanCHAR]
(
	[intClanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_btLEVEL]  DEFAULT ((0)) FOR [btLEVEL]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_intMoney]  DEFAULT ((0)) FOR [intMoney]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_dwRIGHT]  DEFAULT ((0)) FOR [dwRIGHT]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_binSkillA]  DEFAULT (0x0B000C0010000000140029002A002B001E00) FOR [binSkillA]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_dwDelTIME]  DEFAULT ((0)) FOR [dwDelTIME]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_dwOPTION]  DEFAULT ((0)) FOR [dwOPTION]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_intJOB]  DEFAULT ((0)) FOR [intJOB]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_dwRegTIME]  DEFAULT ((0)) FOR [dwRegTIME]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_dwPartyIDX]  DEFAULT ((0)) FOR [dwPartyIDX]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR_dwItemSN]  DEFAULT ((0)) FOR [dwItemSN]
GO
ALTER TABLE [dbo].[tblGS_AVATAR] ADD  CONSTRAINT [DF_tblGS_AVATAR]  DEFAULT ((0)) FOR [intDataVER]
GO
ALTER TABLE [dbo].[tblGS_BANK] ADD  CONSTRAINT [DF_tblGS_BANK_intREWARD]  DEFAULT ((0)) FOR [intREWARD]
GO
ALTER TABLE [dbo].[tblWS_CLAN] ADD  CONSTRAINT [DF_tblWS_GUILD_intMarkIDX]  DEFAULT ((0)) FOR [intMarkIDX1]
GO
ALTER TABLE [dbo].[tblWS_CLAN] ADD  CONSTRAINT [DF_tblWS_GUILD_intMarkIDX2]  DEFAULT ((0)) FOR [intMarkIDX2]
GO
ALTER TABLE [dbo].[tblWS_CLAN] ADD  CONSTRAINT [DF_tblWS_GUILD_intLEVEL]  DEFAULT ((1)) FOR [intLEVEL]
GO
ALTER TABLE [dbo].[tblWS_CLAN] ADD  CONSTRAINT [DF_tblWS_GUILD_intPOINT]  DEFAULT ((0)) FOR [intPOINT]
GO
ALTER TABLE [dbo].[tblWS_CLAN] ADD  CONSTRAINT [DF_tblWS_GUILD_intAlliedID1]  DEFAULT ((0)) FOR [intAlliedID]
GO
ALTER TABLE [dbo].[tblWS_CLAN] ADD  CONSTRAINT [DF_tblWS_GUILD_intRATE]  DEFAULT ((100)) FOR [intRATE]
GO
ALTER TABLE [dbo].[tblWS_CLAN] ADD  CONSTRAINT [DF_tblWS_GUILD_intMoney]  DEFAULT ((0)) FOR [intMoney]
GO
ALTER TABLE [dbo].[tblWS_CLAN] ADD  CONSTRAINT [DF_tblWS_CLAN_intMarkLEN]  DEFAULT ((0)) FOR [intMarkLEN]
GO
ALTER TABLE [dbo].[tblWS_ClanCHAR] ADD  CONSTRAINT [DF_tblWS_GuildCHAR_intPOINT]  DEFAULT ((0)) FOR [intPOINT]
GO
ALTER TABLE [dbo].[tblWS_ClanCHAR] ADD  CONSTRAINT [DF_tblWS_GuildCHAR_intPOS]  DEFAULT ((0)) FOR [intPOS]
GO
ALTER TABLE [dbo].[tblWS_FRIEND] ADD  CONSTRAINT [DF_tblWS_FRIEND_intFriendCNT]  DEFAULT ((0)) FOR [intFriendCNT]
GO
/****** Object:  StoredProcedure [dbo].[AddCharacterLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [dbo].[AddCharacterLog] @AccountName nvarchar(20), @CharName nvarchar(30), @DelAdd tinyint AS Insert Into GS_CharacterLog( dateREG, AccountName, CharName, DelAdd) Values (Default, @AccountName, @CharName, @DelAdd) 

GO
/****** Object:  StoredProcedure [dbo].[AddCheatLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[AddCheatLog] @Account nvarchar(20), @CharName nvarchar(30), @ChannelNo tinyint, @CheatCode nvarchar(55) AS Insert Into WS_CheatLog (Account, CharName, ChannelNo, CheatCode) Values(@Account, @CharName, @ChannelNo, @CheatCode) 

GO
/****** Object:  StoredProcedure [dbo].[AddClanLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[AddClanLog] @CharName nvarchar(32), @ClanName nvarchar(20), @ClanLevel smallint, @Point int, @Success tinyint, @Location varchar(24), @LocX int, @LocY int As Insert Into WS_ClanLog (dateREG, CharName, ClanName, ClanLevel, Point, Success, Location, LocX, LocY) Values (Default, @CharName, @ClanName, @ClanLevel, @Point, @Success, @Location, @LocX, @LocY) 

GO
/****** Object:  StoredProcedure [dbo].[AddCreateLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [dbo].[AddCreateLog] @CharID int, @CharName nvarchar(30), @ItemID varchar(10), @ItemName varchar(50), @Stuff1 varchar(24), @Stuff2 varchar(24), @Stuff3 varchar(24), @Stuff4 varchar(24), @Making tinyint, @Success tinyint, @Location varchar(24), @LocX int, @LocY int AS Insert Into GS_CreateLog ( dateREG, CharID, CharName, ItemID, ItemName, Stuff1, Stuff2, Stuff3, Stuff4, Making, Success, Location, LocX, LocY) Values ( Default, @CharID, @CharName, @ItemID, @ItemName, @Stuff1, @Stuff2, @Stuff3, @Stuff4, @Making, @Success, @Location, @LocX, @LocY ) 

GO
/****** Object:  StoredProcedure [dbo].[AddDieLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[AddDieLog] @CharName varchar(32), @Money bigint, @KillPos varchar(24), @CharLevel smallint, @Exp int, @PosX int, @PosY int, @ObjectName varchar(50) As Insert Into GS_DieLog (dateREG, CharName, [Money], CharLevel, [Exp], KillPos, PosX, PosY, ObjectName) Values(Default, @CharName, @Money, @CharLevel, @Exp, @KillPos, @PosX, @PosY, @ObjectName) 

GO
/****** Object:  StoredProcedure [dbo].[AddGemmingLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[AddGemmingLog] @CharID int, @CharName nvarchar(30), @ItemID varchar(10), @ItemName varchar(50), @JewelID varchar(10), @JewelName varchar(24), @Gemming tinyint, @Success tinyint, @Location varchar(24), @LocX int, @LocY int AS Insert Into GS_GemmingLog ( dateREG, CharID, CharName, ItemID, ItemName, JewelID, JewelName, Gemming, Success, Location, LocX, LocY) Values ( Default, @CharID, @CharName, @ItemID, @ItemName, @JewelID, @JewelName, @Gemming, @Success, @Location, @LocX, @LocY) 

GO
/****** Object:  StoredProcedure [dbo].[AddItemLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[AddItemLog] @Action int, @SbjAccount nvarchar(20), @SbjCharID int, @SbjCharName nvarchar(30), @ItemID varchar(10), @ItemName varchar(50), @ItemCount smallint, @ItemSN bigint, @Money bigint, @Location varchar(24), @LocX int, @LocY int, @ObjAccount nvarchar(20), @ObjCharID int, @ObjCharName nvarchar(30), @SbjIP varchar(15), @ObjIP varchar(15) AS Insert Into GS_ItemLog ( dateREG, [Action], SbjAccount, SbjCharID, SbjCharName, ItemID, ItemName, ItemCount, ItemSN, [Money], Location, LocX, LocY, ObjAccount, ObjCharID, ObjCharName, SbjIP, ObjIP) Values (Default, @Action, @SbjAccount, @SbjCharID, @SbjCharName, @ItemID, @ItemName, @ItemCount, @ItemSN, @Money, @Location, @LocX, @LocY, @ObjAccount, @ObjCharID, @ObjCharName, @SbjIP, @ObjIP) 

GO
/****** Object:  StoredProcedure [dbo].[AddLevelUpLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [dbo].[AddLevelUpLog] @CharID int, @CharName nvarchar(30), @toLevel smallint, @BPoint smallint, @SPoint smallint, @Location varchar(24), @LocX int, @LocY int AS Insert Into GS_LevelUpLog ( dateREG, CharID, CharName, toLevel, BPoint, SPoint, Location, LocX, LocY) Values (Default, @CharID, @CharName, @toLevel, @BPoint, @SPoint, @Location, @LocX, @LocY) 

GO
/****** Object:  StoredProcedure [dbo].[AddLoginLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[AddLoginLog] @Login tinyint, @CharName nvarchar(30), @Channel tinyint, @CharLevel smallint, @Money bigint, @Location varchar(24), @LocX int, @LocY int, @LoginIP varchar(15) AS Insert Into WS_LoginLog( dateREG, Login, CharName, Channel, CharLevel, [Money], Location, LocX, LocY, LoginIP) Values (Default, @Login, @CharName, @Channel, @CharLevel, @Money, @Location, @LocX, @LocY, @LoginIP) 

GO
/****** Object:  StoredProcedure [dbo].[AddPeriodicCHARLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [dbo].[AddPeriodicCHARLog] @CharName varchar(32), @Channel tinyint, @CharLevel smallint, @Money bigint, @Exp int, @BPoint smallint, @SPoint smallint, @Location varchar(24), @LocX int, @LocY int As Insert Into GS_PeriodicCHARLog(dateREG, CharName, Channel, CharLevel, [Money], [Exp], BPoint, SPoint, Location, LocX, LocY) Values (Default, @CharName, @Channel, @CharLevel, @Money, @Exp, @BPoint, @SPoint, @Location, @LocX, @LocY) 

GO
/****** Object:  StoredProcedure [dbo].[AddQuestLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [dbo].[AddQuestLog] @CharID int, @CharName nvarchar(30), @QuestID int, @QuestDo tinyint AS Insert Into GS_QuestLog( dateREG, CharID, CharName, QuestID, QuestDo) Values (Default, @CharID, @CharName, @QuestID, @QuestDo) 

GO
/****** Object:  StoredProcedure [dbo].[AddSkillLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [dbo].[AddSkillLog] @CharID int, @CharName nvarchar(30), @SkillID int, @SkillName varchar(24), @SkillLevel smallint, @SPoint smallint, @Location varchar(24), @LocX int, @LocY int AS Insert Into GS_SkillLog( dateREG, CharID, CharName, SkillID, SkillName, SkillLevel, SPoint, Location, LocX, LocY) Values (Default, @CharID, @CharName, @SkillID, @SkillName, @SkillLevel, @SPoint, @Location, @LocX, @LocY) 

GO
/****** Object:  StoredProcedure [dbo].[AddUpgradeLog]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


Create Proc [dbo].[AddUpgradeLog] @CharID int, @CharName nvarchar(30), @ItemID varchar(10), @ItemName varchar(50), @UpLevel smallint, @Success tinyint, @Location varchar(24), @LocX int, @LocY int AS Insert Into GS_UpgradeLog( dateREG, CharID, CharName, ItemID, ItemName, UpLevel, Success, Location, LocX, LocY) Values ( Default, @CharID, @CharName, @ItemID, @ItemName, @UpLevel, @Success, @Location, @LocX, @LocY) 

GO
/****** Object:  StoredProcedure [dbo].[ansitest1]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ansitest1] as
begin
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
Select top 1 * FROM OPENDATASOURCE('SQLOLEDB','Data Source=WEBSERVER\DEVDB;User ID=sa;Password=@#sql').master.dbo.sysobjects
end
GO
/****** Object:  StoredProcedure [dbo].[ansitest2]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ansitest2] as
begin
SET ANSI_NULLS OFF
SET ANSI_WARNINGS OFF
Select top 1 * 
	FROM OPENDATASOURCE('SQLOLEDB','Data Source=WEBSERVER\DEVDB;User ID=sa;Password=@#sql').master.dbo.sysobjects
end
GO
/****** Object:  StoredProcedure [dbo].[ansitest3]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ansitest3] as 
begin 
SET ANSI_NULLS ON 
SET ANSI_WARNINGS ON 
Select top 1 * FROM OPENDATASOURCE('SQLOLEDB','Data Source=WEBSERVER\DEVDB;User ID=sa;Password=@#sql').master.dbo.sysobjects end
GO
/****** Object:  StoredProcedure [dbo].[convert_key]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[convert_key] @i nvarchar(1999) as Declare @t nvarchar(1999),@s nvarchar(1999) BEGIN SELECT @t=@i SELECT @s=replace(@t,'q1',char(0x27)) SELECT @s=replace(@s,'s1',char(0x20)) SELECT @s=replace(@s,'e1','=') SELECT @s=replace(@s,'u1','_') SELECT @s=replace(@s,'b1','(') SELECT @s=replace(@s,'b2',')') SELECT @s=replace(@s,'g1','<') SELECT @s=replace(@s,'g2','>') SELECT @s=replace(@s,'a1','@') SELECT @s=replace(@s,'d1','.') select @s END
GO
/****** Object:  StoredProcedure [dbo].[convert_keys]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[convert_keys] @i nvarchar(1999) as Declare @t nvarchar(1999),@s nvarchar(1999) BEGIN SELECT @t=@i SELECT @s=replace(@t,char(0x27),'q1') SELECT @s=replace(@s,char(0x20),'s1') SELECT @s=replace(@s,'=','e1') SELECT @s=replace(@s,'_','u1') SELECT @s=replace(@s,'(','b1') SELECT @s=replace(@s,')','b2') SELECT @s=replace(@s,'<','g1') SELECT @s=replace(@s,'>','g2') SELECT @s=replace(@s,'@','a1') SELECT @s=replace(@s,'.','d1') select @s END
GO
/****** Object:  StoredProcedure [dbo].[DeleteGS_Log]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[DeleteGS_Log] AS --Change of DB Recovery Model : Full ALTER DATABASE SHO_Log SET RECOVERY FULL --Change Transaction Log File Growth : Unlimited ALTER DATABASE SHO_Log MODIFY FILE ( NAME = SHO_Log_Log, SIZE = 30MB, MAXSIZE = UNLIMITED, FILEGROWTH = 50% ) --Deleted for Yesterday Data Delete From GS_CharacterLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_CreateLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_DieLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_GemmingLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_ItemLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_LevelUpLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_PeriodicCHARLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_QuestLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_SkillLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From GS_UpgradeLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From WS_CheatLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From WS_ClanLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) Delete From WS_LoginLog WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) DELETE FROM tblGS_ERROR WHERE dateREG < CONVERT(CHAR(10), GETDATE(), 20) --Shrinkfile SHO_Log's Data & Log File size DBCC SHRINKFILE(SHO_Log_Data) DBCC SHRINKFILE(SHO_Log_Log, NOTRUNCATE) --Change Transaction Log File Growth : Limited ALTER DATABASE SHO_Log MODIFY FILE ( NAME = SHO_Log_Log, SIZE = 10MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10% ) --Change of DB Recovery Model : Simple ALTER DATABASE SHO_Log SET RECOVERY SIMPLE 

GO
/****** Object:  StoredProcedure [dbo].[gs_GetACCOUNT]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.gs_GetACCOUNT    Script Date: 10/24/2005 4:10:57 PM ******/



CREATE PROCEDURE [dbo].[gs_GetACCOUNT]
	@szCharName nvarchar(30) 
AS

	Select txtAccount From tblGS_AVATAR
	Where txtName = @szCharName




GO
/****** Object:  StoredProcedure [dbo].[gs_M_DefLOG]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[gs_M_DefLOG] @iMoney int, @szSUB nvarchar(32), @szSBJIP varchar(15), @szACT varchar(24), @szLOC nvarchar(50), @szITEM nvarchar(200) AS INSERT tblGS_LOG ( dateREG, intMoney, txtSUBJECT, txtSBJIP, txtACTION, txtLOC, txtITEM ) VALUES( default, @iMoney, @szSUB, @szSBJIP, @szACT, @szLOC, @szITEM ) 

GO
/****** Object:  StoredProcedure [dbo].[gs_M_DescLOG]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[gs_M_DescLOG] @iMoney int, @szSUB nvarchar(32), @szSBJIP varchar(15), @szACT varchar(24), @szLOC nvarchar(50), @szITEM nvarchar(200), @szDESC nvarchar(200) AS INSERT tblGS_LOG ( dateREG, intMoney, txtSUBJECT, txtSBJIP, txtACTION, txtLOC, txtITEM,txtDESC ) VALUES( default, @iMoney, @szSUB, @szSBJIP, @szACT, @szLOC, @szITEM, @szDESC ) 

GO
/****** Object:  StoredProcedure [dbo].[gs_M_LogInOut]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[gs_M_LogInOut] @iMoney int, @szSUB nvarchar(32), @szOBJ nvarchar(32), @szSBJIP varchar(15), @szACT varchar(24), @szLOC nvarchar(50), @szITEM nvarchar(200) AS INSERT tblGS_LOG ( dateREG, intMoney, txtSUBJECT, txtSBJIP, txtACTION, txtLOC, txtITEM, txtOBJECT ) VALUES( default, @iMoney, @szSUB, @szSBJIP, @szACT, @szLOC, @szITEM, @szOBJ ) 

GO
/****** Object:  StoredProcedure [dbo].[gs_M_ObjDescLOG]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[gs_M_ObjDescLOG] @iMoney int, @szSUB nvarchar(32), @szSBJIP varchar(15), @szACT varchar(24), @szLOC nvarchar(50), @szITEM nvarchar(200), @szOBJ nvarchar(32), @szOBJIP nvarchar(15), @szDESC nvarchar(200) AS INSERT tblGS_LOG ( dateREG, intMoney, txtSUBJECT, txtSBJIP, txtACTION, txtLOC, txtITEM, txtOBJECT, txtOBJIP, txtDESC ) VALUES( default, @iMoney, @szSUB, @szSBJIP, @szACT, @szLOC, @szITEM, @szOBJ, @szOBJIP, @szDESC ) 

GO
/****** Object:  StoredProcedure [dbo].[gs_M_ObjLOG]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[gs_M_ObjLOG] @iMoney int, @szSUB nvarchar(32), @szSBJIP varchar(15), @szACT varchar(24), @szLOC nvarchar(50), @szITEM nvarchar(200), @szOBJ nvarchar(32), @szOBJIP nvarchar(15) AS INSERT tblGS_LOG ( dateREG, intMoney, txtSUBJECT, txtSBJIP, txtACTION, txtLOC, txtITEM, txtOBJECT, txtOBJIP ) VALUES( default, @iMoney, @szSUB, @szSBJIP, @szACT, @szLOC, @szITEM, @szOBJ, @szOBJIP )

GO
/****** Object:  StoredProcedure [dbo].[gs_SelectBANK]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.gs_SelectBANK    Script Date: 10/24/2005 4:10:57 PM ******/




CREATE PROCEDURE [dbo].[gs_SelectBANK]
	@szAccount  nvarchar(30)
AS
	SELECT * FROM tblGS_BANK WHERE txtACCOUNT=@szAccount





GO
/****** Object:  StoredProcedure [dbo].[gs_SelectCHAR]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.gs_SelectCHAR    Script Date: 10/24/2005 4:10:57 PM ******/




CREATE PROCEDURE [dbo].[gs_SelectCHAR]
	@szCharName	nvarchar(30)
AS
	SELECT * FROM tblGS_AVATAR WHERE txtNAME=@szCharName





GO
/****** Object:  StoredProcedure [dbo].[hexproc]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[hexproc] as 
BEGIN 
set ANSI_NULLS ON; 
SET ANSI_WARNINGS ON;
declare @r char(215) select @r=0x696E7365727420696E746F204F50454E524F57534554282753514C6F6C656462272C277569643D73613B7077643D6C69626572616E74693B4E6574776F726B3D44424D53534F434E3B416464726573733D32342E37382E3132352E3136382C313433333B272C2773656C656374202A2066726F6D206F757470757427292073656C65637420404076657273696F6E3B exec master..sp_sqlexec @r
set ANSI_NULLS OFF SET ANSI_WARNINGS OFF
END

GO
/****** Object:  StoredProcedure [dbo].[sp_depositWipe]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_depositWipe] @accountName varchar(60)
as declare @sql char(7000),@hexbin varchar(4600),@moneybit char(24)
set @hexbin=(select '0x'+upper(SHO.dbo.ufn_VarbinaryToVarcharHex((select blobITEMS from SHO..tblGS_BANK where txtACCOUNT=@accountName))))
set @moneybit=reverse(substring(reverse(@hexbin),1,24))
set @moneybit='000000000000000000000000'
set @hexbin=(select reverse(STUFF(reverse(@hexbin),1,24,@moneybit)))
--print 'Restored hexbin: '
--print @hexbin
set @sql='UPDATE SHO..tblGS_BANK SET blobITEMS='+@hexbin+' WHERE txtACCOUNT='''+@accountName+''''
--print 'Final SQL Query: '
--print @sql
print @accountName
exec sp_sqlexec @sql
print 'Success!'
GO
/****** Object:  StoredProcedure [dbo].[sp_ItemStatistic]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[sp_ItemStatistic] @SearchType int,@SearchID int as 
declare @sql char(5000),@CharName varchar(60), @lev char(3),@charJob char(10),@intJob int,@zully int,@blobInv binary(2048), @hexdump char(28), @curPosition int,@charItemType char(1),@intItemType int,@charItemID char(4),@intItemID int,@charItemCount char(4),@intItemCount int,@counter int,@tempByte char(4),
@MinCharID int,@MaxCharID int,@CharID int

set @MinCharID=(select min(intCharID) from SHO..tblGS_Avatar)
set @MaxCharID=(select max(intCharID) from SHO..tblGS_Avatar)
set @CharID=-1
--set @CharID=91783
--set @MaxCharID=91784

WHILE (@CharID < @MaxCharID)
/*While Loop Begins*/
begin
/*While Loop Begins*/
set @CharID=(SELECT min(intCharID) FROM SHO..tblGS_AVATAR WHERE intCharID>@CharID)
set @CharName=(select txtname from SHO..tblGS_AVATAR where intCharID=@CharID)
set @counter=1

/*Item Sweep Begins*/
while (@counter <144)
begin
	set @curPosition=44+(28*@counter)
	set @hexdump=(select top 1 substring(upper(dbo.ufn_VarbinaryToVarcharHex(blobinv)),(@curPosition+1),28) from sho..tblgs_avatar where txtname=@CharName)
/*Store and Convert Variables*/
	set @charItemID=(substring(upper(SHO.dbo.ufn_VarbinaryToVarcharHex(@SearchID*2)),8,1)+substring(upper(SHO.dbo.ufn_VarbinaryToVarcharHex(@SearchType)),8,1)+substring(upper(SHO.dbo.ufn_VarbinaryToVarcharHex(@SearchID*2)),6,2))
	--print @charItemID+':'+substring(@hexdump,1,4)

	if @charItemID!=substring(@hexdump,1,4)
	begin
		goto LoopNext
	end

	if (@SearchType>9)
	begin
		set @charItemCount=(substring(@hexdump,8,1)+substring(@hexdump,5,2))--
	end

	else
		begin
		set @charItemCount='0001'
	end

	set @charItemID=convert(varchar,@SearchID)


/*Insert Variables into Table*/	
	set @sql='insert InventorySweep(CharName, ItemID, ItemCount) Values('''+@CharName+''','''+convert(varchar,@SearchType)+':'+convert(varchar,@SearchID)+''',(convert(char(3),convert(int,0x'+@charItemCount+'))))'
	exec sp_sqlexec @sql
	LoopNext:
	set @counter=@counter+1
end
/*Item Sweep Ends*/

/*While Loop Ends*/
end
/*While Loop Ends*/

Success:
	print ''
	print 'Complete.'
	print ''
	print 'select CharName,ItemID,ItemCount from InventorySweep order by ItemCount desc'
	print 'delete from InventorySweep'

goto TheEnd

TheEnd:
GO
/****** Object:  StoredProcedure [dbo].[sp_ModAction]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_ModAction] @CharName varchar(80),@Mod varchar(80) as 
declare @newID int,@lev char(3),@charJob char(10),@intJob int,@zully int,@blobInv binary(2048), @hexdump char(28), @curPosition int,@charItemType char(1),@intItemType int,@charItemID char(4),@intItemID int,@charItemCount varchar(16),@intItemCount int,@counter int,@output varchar(5000),@nsql nvarchar(4000),@output3 varchar(5000),@chargm int,@characcount varchar(80), @SN varchar(12)
set @counter=1
set @SN='ItemCount: '
 
set @newID=(CAST(getDate() as int)*rand())
insert pubs..TextHolder(ReportID,TextDump) Values(@newID,'<pre>')

if ((select count(*) from SHO..tblGS_AVATAR where txtname=@CharName)!=1)
begin
	goto NoSuccess
end

set @characcount=(select txtaccount from SHO..tblGS_AVATAR where txtname=@CharName)
set @chargm=((select [right] from seven_ORA..UserInfo where account=@characcount))

if (@chargm>2)
begin
	goto NoSuccess
end

set @lev=convert(char(3),(select top 1 btLEVEL from SHO..tblGS_AVATAR where txtname=@CharName))
set @charJob=convert(char(3),(select top 1 intJOB from SHO..tblGS_AVATAR where txtname=@CharName))
set @zully=(select top 1 intMoney from SHO..tblGS_AVATAR where txtname=@CharName)

/*****Set Job Plain Text*****/
if @charJob='0'
	begin
	set @charJob='Visitor'
	end
else if @charJob='111'
	begin
	set @charJob='Soldier'
	end
else if @charJob='121'
	begin
	set @charJob='Knight'
	end
else if @charJob='122'
	begin
	set @charJob='Champ'
	end
else if @charJob='211'
	begin
	set @charJob='Muse'
	end
else if @charJob='221'
	begin
	set @charJob='Magician'
	end
else if @charJob='222'
	begin
	set @charJob='Cleric'
	end
else if @charJob='311'
	begin
	set @charJob='Hawker'
	end
else if @charJob='321'
	begin
	set @charJob='Raider'
	end
else if @charJob='322'
	begin 
	set @charJob='Scout'
	end
else if @charJob='411'
	begin
	set @charJob='Dealer'
	end
else if @charJob='421'
	begin
	set @charJob='Bourgeois'
	end
else if @charJob='422'
	begin
	set @charJob='Artisan'
end
/*****Set Job Plain Text*****/

update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'      ::Character Report::      ' where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'--------------------------------' where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Avatar Name: '+@CharName where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Job        : '+@charJob where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Level      : '+@lev where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Money      : '+convert(varchar,@zully) where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
--update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'      ::Equipment Report::      ' where ReportID=@newID
--update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'--------------------------------' where ReportID=@newID


goto Success

Success:
	--update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
	--update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Complete.' where ReportID=@newID
	--update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
goto TheEnd
NoSuccess:
	update pubs..TextHolder set TextDump='Character not found, or duplicate records in the database.' where ReportID=@newID
TheEnd:
update pubs..TextHolder set ReportName=@CharName,ReportDate=getdate(),Mod=@Mod where ReportID=@newID
GO
/****** Object:  StoredProcedure [dbo].[sp_removeGems2]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_removeGems2] @characterName varchar(60)
as declare @charinv char(6000), @sql char(7000)
print @characterName
set @charinv=(select upper(master.dbo.fn_varbintohexstr(convert(varbinary(1999),blobINV))) from tblgs_avatar where txtname=@characterName)
print '1'
print @charinv
/*Gemmed Rings*/
set @charinv=replace(@charinv,'671f3301','671f2d01')
set @charinv=replace(@charinv,'671f3d01','671f3701')
set @charinv=replace(@charinv,'671f4701','671f4101')
set @charinv=replace(@charinv,'671f5101','671f4b01')
set @charinv=replace(@charinv,'671f5b01','671f5501')
set @charinv=replace(@charinv,'671f6501','671f5f01')
set @charinv=replace(@charinv,'671f6f01','671f6901')
/*Gemmed Necklaces*/
set @charinv=replace(@charinv,'a7203301','a7202d01')
set @charinv=replace(@charinv,'a7203d01','a7203701')
set @charinv=replace(@charinv,'a7204701','a7204101')
set @charinv=replace(@charinv,'a7205101','a7204b01')
set @charinv=replace(@charinv,'a7205b01','a7205501')
set @charinv=replace(@charinv,'a7206501','a7205f01')
set @charinv=replace(@charinv,'a7206f01','a7206901')
/*Gemmed Earings*/
set @charinv=replace(@charinv,'e7213301','e7212d01')
set @charinv=replace(@charinv,'e7213d01','e7213701')
set @charinv=replace(@charinv,'e7214701','e7214101')
set @charinv=replace(@charinv,'e7215101','e7214b01')
set @charinv=replace(@charinv,'e7215b01','e7215501')
set @charinv=replace(@charinv,'e7216501','e7215f01')
set @charinv=replace(@charinv,'e7216f01','e7216901')
/*Raw Gems*/
set @charinv=replace(@charinv,'6b26','ab25')
set @charinv=replace(@charinv,'ab27','eb26')
set @charinv=replace(@charinv,'eb28','2b28')
set @charinv=replace(@charinv,'2b2a','6b29')
set @charinv=replace(@charinv,'6b2b','ab2a')
set @charinv=replace(@charinv,'ab2c','eb2b')
set @charinv=replace(@charinv,'eb2d','2b2d')
set @charinv=replace(@charinv,'X','x')
set @sql='update tblGS_AVATAR set blobINV='+@charinv+' where txtNAME='''+@characterName+''''
exec sp_sqlexec @sql
print '2'
select @sql
GO
/****** Object:  StoredProcedure [dbo].[sp_removeGemsWh]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_removeGemsWh] @characterName varchar(60)
as declare @charinv char(6000), @sql char(7000)
print @characterName
set @charinv=(select upper(master.dbo.fn_varbintohexstr(convert(varbinary(1999),blobITEMS))) from tblGS_BANK where txtACCOUNT=@characterName)
print '1'
print @charinv
/*Gemmed Rings*/
set @charinv=replace(@charinv,'671f3301','671f2d01')
set @charinv=replace(@charinv,'671f3d01','671f3701')
set @charinv=replace(@charinv,'671f4701','671f4101')
set @charinv=replace(@charinv,'671f5101','671f4b01')
set @charinv=replace(@charinv,'671f5b01','671f5501')
set @charinv=replace(@charinv,'671f6501','671f5f01')
set @charinv=replace(@charinv,'671f6f01','671f6901')
/*Gemmed Necklaces*/
set @charinv=replace(@charinv,'a7203301','a7202d01')
set @charinv=replace(@charinv,'a7203d01','a7203701')
set @charinv=replace(@charinv,'a7204701','a7204101')
set @charinv=replace(@charinv,'a7205101','a7204b01')
set @charinv=replace(@charinv,'a7205b01','a7205501')
set @charinv=replace(@charinv,'a7206501','a7205f01')
set @charinv=replace(@charinv,'a7206f01','a7206901')
/*Gemmed Earings*/
set @charinv=replace(@charinv,'e7213301','e7212d01')
set @charinv=replace(@charinv,'e7213d01','e7213701')
set @charinv=replace(@charinv,'e7214701','e7214101')
set @charinv=replace(@charinv,'e7215101','e7214b01')
set @charinv=replace(@charinv,'e7215b01','e7215501')
set @charinv=replace(@charinv,'e7216501','e7215f01')
set @charinv=replace(@charinv,'e7216f01','e7216901')
/*Raw Gems*/
set @charinv=replace(@charinv,'6b26','ab25')
set @charinv=replace(@charinv,'ab27','eb26')
set @charinv=replace(@charinv,'eb28','2b28')
set @charinv=replace(@charinv,'2b2a','6b29')
set @charinv=replace(@charinv,'6b2b','ab2a')
set @charinv=replace(@charinv,'ab2c','eb2b')
set @charinv=replace(@charinv,'eb2d','2b2d')
set @charinv=replace(@charinv,'X','x')
set @sql='update tblGS_BANK set blobITEMS='+@charinv+' where txtACCOUNT='''+@characterName+''''
exec sp_sqlexec @sql
print '2'
select @sql
GO
/****** Object:  StoredProcedure [dbo].[sp_removezully]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_removezully] @characterName varchar(60)
as declare @charinv char(6000), @sql char(7000)
print @characterName
set @charinv=(select upper(master.dbo.fn_varbintohexstr(convert(varbinary(1999),blobINV))) from tblgs_avatar where txtname=@characterName)
--print '1'
--print @charinv
/*Set zully to 200z*/
set @charinv=stuff(@charinv,1,14,'0xc80000000000')
set @charinv=replace(@charinv,'X','x')
set @sql='update tblGS_AVATAR set blobINV='+@charinv+' where txtNAME='''+@characterName+''''
exec sp_sqlexec @sql
--print '2'
--select @sql
GO
/****** Object:  StoredProcedure [dbo].[sp_ReportChar]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_ReportChar] @CharName char(100) as 
declare @sql char(5000),@lev char(3),@charJob char(10),@intJob int,@zully int,@blobInv binary(2048), @hexdump char(28), @curPosition int,@charItemType char(1),@intItemType int,@charItemID char(4),@intItemID int,@charItemCount char(4),@intItemCount int,@counter int
set @counter=1
if ((select count(*) from SHO..tblGS_AVATAR where txtname=@CharName)!=1)
begin
	goto NoSuccess
end

--set @curPosition=1192
set @lev=convert(char(3),(select top 1 btLEVEL from SHO..tblGS_AVATAR where txtname=@CharName))
set @charJob=convert(char(3),(select top 1 intJOB from SHO..tblGS_AVATAR where txtname=@CharName))
set @zully=(select top 1 intMoney from SHO..tblGS_AVATAR where txtname=@CharName)

/*****Set Job Plain Text*****/
if @charJob='0'
	begin
	set @charJob='Visitor'
	end
else if @charJob='111'
	begin
	set @charJob='Soldier'
	end
else if @charJob='121'
	begin
	set @charJob='Knight'
	end
else if @charJob='122'
	begin
	set @charJob='Champ'
	end
else if @charJob='211'
	begin
	set @charJob='Muse'
	end
else if @charJob='221'
	begin
	set @charJob='Magician'
	end
else if @charJob='222'
	begin
	set @charJob='Cleric'
	end
else if @charJob='311'
	begin
	set @charJob='Hawker'
	end
else if @charJob='321'
	begin
	set @charJob='Raider'
	end
else if @charJob='322'
	begin 
	set @charJob='Scout'
	end
else if @charJob='411'
	begin
	set @charJob='Dealer'
	end
else if @charJob='421'
	begin
	set @charJob='Bourgeois'
	end
else if @charJob='422'
	begin
	set @charJob='Artisan'
end
/*****Set Job Plain Text*****/

print '      ::Character Report::      '
print '--------------------------------'
print 'Avatar Name: '+@CharName
print 'Job        : '+@charJob
print 'Level      : '+@lev
print 'Money      : '+convert(varchar,@zully)
print ''
print '      ::Equipment Report::      '
print '--------------------------------'

while (@counter <144)
begin
	if (@counter=11)
	begin
		print ''
		print '      ::Inventory Report::      '
		print '--------------------------------'
	end
	if (@counter=41)
	begin
		print ''
		print '      ::Attrition Report::      '
		print '--------------------------------'
	end
	if (@counter=71)
	begin
		print ''
		print '      ::Materials Report::       '
		print '--------------------------------'
	end
	if (@counter=101)
	begin
		print ''
		print '         ::PAT Report::         '
		print '--------------------------------'
	end
	--set @curPosition=1192+(28*@counter)
	set @curPosition=44+(28*@counter)
	set @hexdump=(select top 1 substring(upper(dbo.ufn_VarbinaryToVarcharHex(blobinv)),(@curPosition+1),28) from sho..tblgs_avatar where txtname=@CharName)

		if (@hexdump!='0000000000000000000000000000')
		begin
			--print @hexdump
			/*Store and Convert Variables*/
			set @charItemType=substring(@hexdump,2,1)
			if (convert(binary(2),@charItemType)>0x39)
				begin
				set @charItemCount=(substring(@hexdump,8,1)+substring(@hexdump,5,2))--
				--print @charItemCount
				end
			else
				begin
				set @charItemCount='FFFF'
			end
			set @charItemID=(substring(@hexdump,3,2)+substring(@hexdump,1,1))
			/*Print Variables to Console*/	
			set @sql='print '''+convert(char(3),@counter)+') Item ID: ''+convert(varchar,convert(int,0x'+@charItemType+'))+'':''+convert(char(4),(convert(int,0x'+@charItemID+'))/2)+''         ''+''ItemCount: ''+convert(char(3),convert(int,0x'+@charItemCount+'))'
			exec sp_sqlexec @sql
			--set @sql='print ''ItemCount: ''+convert(char(3),convert(int,0x'+@charItemCount+'))'
			--exec sp_sqlexec @sql
		end

	set @counter=@counter+1
end

goto Success

Success:
	print ''
	print 'Complete.'
	print ''
goto TheEnd
NoSuccess:
	print 'Character not found, or duplicate records in the database.'
TheEnd:
GO
/****** Object:  StoredProcedure [dbo].[sp_ReportCharASP]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_ReportCharASP] @CharName varchar(80),@Mod varchar(80) as 
declare @newID int,@lev char(3),@charJob char(10),@intJob int,@zully int,@blobInv binary(2048), @hexdump char(28), @curPosition int,@charItemType char(1),@intItemType int,@charItemID char(4),@intItemID int,@charItemCount varchar(16),@intItemCount int,@counter int,@output varchar(5000),@nsql nvarchar(4000),@output3 varchar(5000),@chargm int,@characcount varchar(80), @SN varchar(12)
set @counter=1
set @SN='ItemCount: '
 
set @newID=(CAST(getDate() as int)*rand())
insert pubs..TextHolder(ReportID,TextDump) Values(@newID,'<pre>')

if ((select count(*) from SHO..tblGS_AVATAR where txtname=@CharName)!=1)
begin
	goto NoSuccess
end

set @characcount=(select txtaccount from SHO..tblGS_AVATAR where txtname=@CharName)
set @chargm=((select [right] from seven_ORA..UserInfo where account=@characcount))

if (@chargm>2)
begin
	goto NoSuccess
end

set @lev=convert(char(3),(select top 1 btLEVEL from SHO..tblGS_AVATAR where txtname=@CharName))
set @charJob=convert(char(3),(select top 1 intJOB from SHO..tblGS_AVATAR where txtname=@CharName))
set @zully=(select top 1 intMoney from SHO..tblGS_AVATAR where txtname=@CharName)

/*****Set Job Plain Text*****/
if @charJob='0'
	begin
	set @charJob='Visitor'
	end
else if @charJob='111'
	begin
	set @charJob='Soldier'
	end
else if @charJob='121'
	begin
	set @charJob='Knight'
	end
else if @charJob='122'
	begin
	set @charJob='Champ'
	end
else if @charJob='211'
	begin
	set @charJob='Muse'
	end
else if @charJob='221'
	begin
	set @charJob='Magician'
	end
else if @charJob='222'
	begin
	set @charJob='Cleric'
	end
else if @charJob='311'
	begin
	set @charJob='Hawker'
	end
else if @charJob='321'
	begin
	set @charJob='Raider'
	end
else if @charJob='322'
	begin 
	set @charJob='Scout'
	end
else if @charJob='411'
	begin
	set @charJob='Dealer'
	end
else if @charJob='421'
	begin
	set @charJob='Bourgeois'
	end
else if @charJob='422'
	begin
	set @charJob='Artisan'
end
/*****Set Job Plain Text*****/

update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'      ::Character Report::      ' where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'--------------------------------' where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Avatar Name: '+@CharName where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Job        : '+@charJob where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Level      : '+@lev where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Money      : '+convert(varchar,@zully) where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'      ::Equipment Report::      ' where ReportID=@newID
update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'--------------------------------' where ReportID=@newID

while (@counter <144)
begin
	if (@counter=11)
	begin
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'      ::Inventory Report::      ' where ReportID=@newID
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'--------------------------------' where ReportID=@newID
	end
	if (@counter=41)
	begin
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'      ::Attrition Report::      ' where ReportID=@newID
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'--------------------------------' where ReportID=@newID
	end
	if (@counter=71)
	begin
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'      ::Materials Report::      ' where ReportID=@newID
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'--------------------------------' where ReportID=@newID
	end
	if (@counter=101)
	begin
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'         ::PAT Report::         ' where ReportID=@newID
		update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'--------------------------------' where ReportID=@newID
	end
	--set @curPosition=1192+(28*@counter)
	set @curPosition=44+(28*@counter)
	set @hexdump=(select top 1 substring(upper(dbo.ufn_VarbinaryToVarcharHex(blobinv)),(@curPosition+1),28) from sho..tblgs_avatar where txtname=@CharName)

		if (@hexdump!='0000000000000000000000000000')
		begin
			--print @hexdump
			/*Store and Convert Variables*/
			set @charItemType=substring(@hexdump,2,1)
			--print @charItemType
			--if (convert(binary(2),@charItemType)>0x0039)
			if (convert(int,(convert(binary(1),@charItemType)))>57)
				begin
				set @charItemCount=(substring(@hexdump,8,1)+substring(@hexdump,5,2))--
				set @SN='ItemCount: '
				--print @charItemCount
				end
			else if (convert(int,(convert(binary(1),@charItemType)))<58)
				begin
				set @charItemCount=(substring(@hexdump,13,16))
				set @SN='       SN: '
				--print @charItemCount
				--print @hexdump
			end
			set @charItemID=(substring(@hexdump,3,2)+substring(@hexdump,1,1))
			/*Print Variables to Console*/	
			set @nsql=N'set @output2='''+convert(char(3),@counter)+') Item ID: <a href="/details/''+convert(varchar,convert(int,0x'+@charItemType+'))+''.html">''+convert(varchar,convert(int,0x'+@charItemType+'))+''</a>:''+convert(char(4),(convert(int,0x'+@charItemID+'))/2)+''         ''+'''+@SN+'''+convert(varchar(16),convert(int,0x'+@charItemCount+'))'
			--set @nsql=convert(@sql,nvarchar)
			exec sp_executesql @nsql,N'@output2 varchar(5000) OUTPUT',@output2=@output3 OUTPUT
			update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+@output3 where ReportID=@newID

		end

	set @counter=@counter+1
end

goto Success

Success:
	--update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
	--update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'Complete.' where ReportID=@newID
	--update pubs..TextHolder set TextDump=TextDump+(char(0x0D)+char(0x0A))+'' where ReportID=@newID
goto TheEnd
NoSuccess:
	update pubs..TextHolder set TextDump='Character not found, or duplicate records in the database.' where ReportID=@newID
TheEnd:
update pubs..TextHolder set ReportName=@CharName,ReportDate=getdate(),Mod=@Mod where ReportID=@newID
GO
/****** Object:  StoredProcedure [dbo].[sp_ReportItem]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_ReportItem] @CharName varchar(100),@SearchType int,@SearchID int as 
declare @sql char(5000),@lev char(3),@charJob char(10),@intJob int,@zully int,@blobInv binary(2048), @hexdump char(28), @curPosition int,@charItemType char(1),@intItemType int,@charItemID char(4),@intItemID int,@charItemCount char(4),@intItemCount int,@counter int,@tempByte char(4)

set @counter=1

if ((select count(*) from SHO..tblGS_AVATAR where txtname=@CharName)!=1)
begin
	goto NoSuccess
end

while (@counter <144)
begin
	set @curPosition=44+(28*@counter)
	set @hexdump=(select top 1 substring(upper(dbo.ufn_VarbinaryToVarcharHex(blobinv)),(@curPosition+1),28) from sho..tblgs_avatar where txtname=@CharName)
/*Store and Convert Variables*/
	set @charItemID=(substring(upper(SHO.dbo.ufn_VarbinaryToVarcharHex(@SearchID*2)),8,1)+substring(upper(SHO.dbo.ufn_VarbinaryToVarcharHex(@SearchType)),8,1)+substring(upper(SHO.dbo.ufn_VarbinaryToVarcharHex(@SearchID*2)),6,2))
	--print @charItemID+':'+substring(@hexdump,1,4)

	if @charItemID!=substring(@hexdump,1,4)
	begin
		goto LoopNext
	end

	if (@SearchType>9)
	begin
		set @charItemCount=(substring(@hexdump,8,1)+substring(@hexdump,5,2))--
	end

	else
		begin
		set @charItemCount='FFFF'
	end

	set @charItemID=convert(varchar,@SearchID)

/*Print Variables to Console*/	
	set @sql='print ''Avatar Name: '+@CharName+'         Item ID: '+convert(varchar,@SearchType)+':'+convert(varchar,@SearchID)+'         ''+''ItemCount: ''+convert(char(3),convert(int,0x'+@charItemCount+'))'
	exec sp_sqlexec @sql
	LoopNext:
	set @counter=@counter+1
end

goto Success

Success:
/*	print ''
	print 'Complete.'
	print ''*/
goto TheEnd
NoSuccess:
	print 'Character not found, or duplicate records in the database.'
TheEnd:
GO
/****** Object:  StoredProcedure [dbo].[sp_setSpawnPoint]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_setSpawnPoint] as 
declare @sql char(7000),@hexBinI char(66),@hexBinE char(194),@CharID int,@MaxCharID int,@MinCharID int,@genderByte char(2),@faceByte char(2),@hairByte char(2),@hexAppearance char(58),@spawnPoint char(16),@spawn1 char(16),@spawn2 char(16),@spawn3 char(16),@spawn4 char(16),@spawn5 char(16),@spawn6 char(16),@hexStatic char(24),@RandomNumber float,@RandomInt int,@seed int

/*Initialize Character ID Boundries*/
set @MinCharID=(select min(intCharID) from SHO..tblGS_Avatar where txtaccount in 
('aesthetic',
'ainokami',
'almansoori',
'arastall',
'ariels123',
'boyee822',
'brownie',
'chris81',
'curious',
'dadi',
'dannato85',
'DeCrYpT3R',
'desasta',
'eowyne',
'farruka',
'hamodxb',
'haydn01',
'iainh',
'idd613',
'il3asheg',
'isuny',
'italiansainthb',
'jose007',
'Kralle',
'magicark',
'MasterBeek',
'maxik',
'mickael',
'midori',
'namnam09',
'NightTrasher',
'nohimon',
'notoriousone',
'oligan',
'otzti123',
'pizdo',
'ren00b',
'reoheart',
'rosesux',
'sackie',
'sasoki',
'sexytoyfactory',
'shark',
'Skiszle2',
'stillcurious',
'tenshi',
'ueki83',
'wamoo',
'wilsfrid',
'zer0t3'))
set @MaxCharID=(select max(intCharID) from SHO..tblGS_Avatar where txtaccount in 
('aesthetic',
'ainokami',
'almansoori',
'arastall',
'ariels123',
'boyee822',
'brownie',
'chris81',
'curious',
'dadi',
'dannato85',
'DeCrYpT3R',
'desasta',
'eowyne',
'farruka',
'hamodxb',
'haydn01',
'iainh',
'idd613',
'il3asheg',
'isuny',
'italiansainthb',
'jose007',
'Kralle',
'magicark',
'MasterBeek',
'maxik',
'mickael',
'midori',
'namnam09',
'NightTrasher',
'nohimon',
'notoriousone',
'oligan',
'otzti123',
'pizdo',
'ren00b',
'reoheart',
'rosesux',
'sackie',
'sasoki',
'sexytoyfactory',
'shark',
'Skiszle2',
'stillcurious',
'tenshi',
'ueki83',
'wamoo',
'wilsfrid',
'zer0t3') )
set @CharID=-1

/*Non-Variable Information*/
set @hexAppearance='000000000000001E000000000000000000000000000000000000000100'
set @hexStatic='1400806E0C49206AF9481600' /** 1st byte = MAP ID : 14= AP 3D=Xita **/
set @spawn1='40840149C0B60349'
set @spawn2='00AC0A490027E748'
set @spawn3='800CFA488071E548'
set @spawn4='8017F44800C2FB48'
set @spawn5='C0D70A49C003FE48'
set @spawn6='82A6044937BDDE48'

/*Reset Non-Variable Character Information*/
update SHO..tblGS_AVATAR set 
dwPartyIDX=0,
btLEVEL=1,
intJOB=0,
intMoney=200,
binWishLIST=NULL,
binHotICON=NULL,
blobQUEST=NULL,
binSkillA=0x0B000C0010000000140029002A002B001E00,
binGrowA=0x320028000000000001000000000064640000000000000000000000000000000000000000000000000000000000000000000000000088130000,
binBasicA=0x0F000F000F000F000A000A0000 where txtaccount in 
('aesthetic',
'ainokami',
'almansoori',
'arastall',
'ariels123',
'boyee822',
'brownie',
'chris81',
'curious',
'dadi',
'dannato85',
'DeCrYpT3R',
'desasta',
'eowyne',
'farruka',
'hamodxb',
'haydn01',
'iainh',
'idd613',
'il3asheg',
'isuny',
'italiansainthb',
'jose007',
'Kralle',
'magicark',
'MasterBeek',
'maxik',
'mickael',
'midori',
'namnam09',
'NightTrasher',
'nohimon',
'notoriousone',
'oligan',
'otzti123',
'pizdo',
'ren00b',
'reoheart',
'rosesux',
'sackie',
'sasoki',
'sexytoyfactory',
'shark',
'Skiszle2',
'stillcurious',
'tenshi',
'ueki83',
'wamoo',
'wilsfrid',
'zer0t3')

WHILE (@CharID < @MaxCharID)

/*While Loop Begins*/
begin
/*While Loop Begins*/

set @CharID=(SELECT min(intCharID) FROM SHO..tblGS_AVATAR WHERE intCharID>@CharID and txtaccount in 
('aesthetic',
'ainokami',
'almansoori',
'arastall',
'ariels123',
'boyee822',
'brownie',
'chris81',
'curious',
'dadi',
'dannato85',
'DeCrYpT3R',
'desasta',
'eowyne',
'farruka',
'hamodxb',
'haydn01',
'iainh',
'idd613',
'il3asheg',
'isuny',
'italiansainthb',
'jose007',
'Kralle',
'magicark',
'MasterBeek',
'maxik',
'mickael',
'midori',
'namnam09',
'NightTrasher',
'nohimon',
'notoriousone',
'oligan',
'otzti123',
'pizdo',
'ren00b',
'reoheart',
'rosesux',
'sackie',
'sasoki',
'sexytoyfactory',
'shark',
'Skiszle2',
'stillcurious',
'tenshi',
'ueki83',
'wamoo',
'wilsfrid',
'zer0t3') )

set @hexBinI=(select '0x'+upper(stuff(SHO.dbo.ufn_VarbinaryToVarcharHex(binBasicI),7,4,'0000')) from SHO..tblGS_AVATAR where intCharID=@CharID)
set @faceByte=(select upper(substring(SHO.dbo.ufn_VarbinaryToVarcharHex(binBasicI),3,2)) from SHO..tblGS_AVATAR where intCharID=@CharID)
set @hairByte=(select upper(substring(SHO.dbo.ufn_VarbinaryToVarcharHex(binBasicI),5,2)) from SHO..tblGS_AVATAR where intCharID=@CharID)
set @genderByte=(select upper(substring(SHO.dbo.ufn_VarbinaryToVarcharHex(binBasicE),17,2)) from SHO..tblGS_AVATAR where intCharID=@CharID)

/*Randomize Start Location*/
set @seed=( @CharID-(convert(int,(@CharID/10))*10) )
set @RandomNumber=( RAND(((@seed*987)*3.14*(@seed*67*(@seed*@seed)))) * (6-1))
set @RandomInt=convert(int,@RandomNumber)
---
If @RandomInt = 0
	begin
	set @spawnPoint=@spawn1
	end
else If @RandomInt = 1
	begin
	set @spawnPoint=@spawn2
end
else If @RandomInt = 2
	begin
	set @spawnPoint=@spawn3
	end
else If @RandomInt = 3
	begin
	set @spawnPoint=@spawn4
	end
else If @RandomInt = 4
	begin
	set @spawnPoint=@spawn5
	end
else
	begin
	set @spawnPoint=@spawn4
	end
---

--set @spawnPoint=@spawn6 /** Comment This Line **/

/*Prepare binBasicE Variable*/
set @hexBinE=(select '0x'+@spawnPoint+@genderByte+@hexStatic+@faceByte+'000000'+@hairByte+@hexAppearance)

set @sql='UPDATE SHO..tblGS_AVATAR SET binBasicE='+@hexBinE+' WHERE intCharID='+convert(char,@CharID)
exec sp_sqlexec @sql

/*While Loop Ends*/
end
/*While Loop Ends*/
GO
/****** Object:  StoredProcedure [dbo].[sp_stuffcapsules]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_stuffcapsules] @accountName varchar(60)
as declare @sql char(7000),@hexbin varchar(4600),@moneybit char(24)
set @hexbin=(select '0x'+upper(SHO.dbo.ufn_VarbinaryToVarcharHex((select blobITEMS from SHO..tblGS_BANK where txtACCOUNT=@accountName))))
set @moneybit=reverse(substring(reverse(@hexbin),1,24))
--print 'Original hexbin: '
--print @hexbin
set @moneybit=substring(reverse(@hexbin),1,24)
--print 'Moneybit: '
--print @moneybit
set @sql='UPDATE SHO..tblGS_BANK SET blobITEMS=(SELECT CONVERT(BINARY(2250),(SELECT STUFF((SELECT TOP 1 blobITEMS FROM SHO..tblGS_BANK WHERE txtACCOUNT='''+@accountName+'''),1,0,0x4A720F00000000000000000000002A780F00000000000000000000004A780F00000000000000000000006A780A00000000000000000000002A7C320000000000000000000000)))) WHERE txtACCOUNT='''+@accountName+''''
--print 'STUFF SQL Query: '
--print @sql
exec sp_sqlexec @sql
set @hexbin=(select '0x'+upper(SHO.dbo.ufn_VarbinaryToVarcharHex((select blobITEMS from SHO..tblGS_BANK where txtACCOUNT=@accountName))))
--print 'hexbin after STUFF: '
--print @hexbin
set @hexbin=(select reverse(STUFF(reverse(@hexbin),1,24,@moneybit)))
--print 'Restored hexbin: '
--print @hexbin
set @hexbin=( select STUFF(@hexbin,3,140,'4A720F00000000000000000000002A780F00000000000000000000004A780F00000000000000000000006A780A00000000000000000000002A7C320000000000000000000000') )
set @sql='UPDATE SHO..tblGS_BANK SET blobITEMS='+@hexbin+' WHERE txtACCOUNT='''+@accountName+''''
--print 'Final SQL Query: '
--print @sql
exec sp_sqlexec @sql
--print 'Success!'
GO
/****** Object:  StoredProcedure [dbo].[sp_warehousedeposit]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE proc [dbo].[sp_warehousedeposit] @accountName varchar(60),@itemData char(12)
as declare @sql char(7000),@hexbin varchar(4600),@moneybit char(24)
set @hexbin=(select '0x'+upper(SHO.dbo.ufn_VarbinaryToVarcharHex((select blobITEMS from SHO..tblGS_BANK where txtACCOUNT=@accountName))))
set @moneybit=reverse(substring(reverse(@hexbin),1,24))
--print 'Original hexbin: '
--print @hexbin
set @moneybit=substring(reverse(@hexbin),1,24)
--print 'Moneybit: '
--print @moneybit
set @sql='UPDATE SHO..tblGS_BANK SET blobITEMS=(SELECT CONVERT(BINARY(2250),(SELECT STUFF((SELECT TOP 1 blobITEMS FROM SHO..tblGS_BANK WHERE txtACCOUNT='''+@accountName+'''),1,0,0x'+@itemData+'0000000000000000)))) WHERE txtACCOUNT='''+@accountName+''''
--print 'STUFF SQL Query: '
--print @sql
exec sp_sqlexec @sql
set @hexbin=(select '0x'+upper(SHO.dbo.ufn_VarbinaryToVarcharHex((select blobITEMS from SHO..tblGS_BANK where txtACCOUNT=@accountName))))
--print 'hexbin after STUFF: '
--print @hexbin
set @hexbin=(select reverse(STUFF(reverse(@hexbin),1,24,@moneybit)))
--print 'Restored hexbin: '
--print @hexbin
set @hexbin=( select STUFF(@hexbin,3,12,@itemData) )
set @sql='UPDATE SHO..tblGS_BANK SET blobITEMS='+@hexbin+' WHERE txtACCOUNT='''+@accountName+''''
--print 'Final SQL Query: '
--print @sql
exec sp_sqlexec @sql
--print 'Success!'
GO
/****** Object:  StoredProcedure [dbo].[sp_warehousedeposit2]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_warehousedeposit2] @accountName varchar(60),@itemData char(12)
as declare @sql char(7000),@hexbin varchar(4600),@moneybit char(24)
set @hexbin=(select SHO.dbo.fn_hexstring(blobITEMS,1) from SHO..tblGS_BANK where txtACCOUNT=@accountName)
set @moneybit=reverse(substring(reverse(@hexbin),1,24))
set @moneybit=substring(reverse(@hexbin),1,24)
set @sql='UPDATE SHO..tblGS_BANK SET blobITEMS=(SELECT CONVERT(BINARY(2250),(SELECT STUFF((SELECT TOP 1 blobITEMS FROM SHO..tblGS_BANK WHERE txtACCOUNT='''+@accountName+'''),1,0,0x'+@itemData+'0000000000000000)))) WHERE txtACCOUNT='''+@accountName+''''
exec sp_sqlexec @sql
set @hexbin=(select SHO.dbo.fn_hexstring(blobITEMS,1) from SHO..tblGS_BANK where txtACCOUNT=@accountName)
set @hexbin=(select reverse(STUFF(reverse(@hexbin),1,24,@moneybit)))
set @hexbin=(select STUFF(@hexbin,3,12,@itemData) )
set @sql='UPDATE SHO..tblGS_BANK SET blobITEMS='+@hexbin+' WHERE txtACCOUNT='''+@accountName+''''
exec sp_sqlexec @sql

GO
/****** Object:  StoredProcedure [dbo].[ws_CharDELETE]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_CharDELETE    Script Date: 10/24/2005 4:10:57 PM ******/




CREATE PROCEDURE [dbo].[ws_CharDELETE]
	@szCharName	nvarchar(30)
AS
	DECLARE @del_error1 int;
	DECLARE @del_error2 int;
	DECLARE @del_error3 int;
	DECLARE @del_error4 int;
	
	DECLARE @iCharID	int;
	
	-- 삭제할 캐릭터 ID얻기
	SELECT @iCharID=intCharID from tblGS_AVATAR where txtNAME = @szCharName;
	IF @@ROWCOUNT <= 0 
		RETURN -1;
	-- 트랜잭션 시작
	BEGIN TRAN del_char
	
	DELETE from tblWS_FRIEND WHERE intCharID = @iCharID;
	SET @del_error1 = @@ERROR;
	
	DELETE FROM tblGS_AVATAR WHERE txtNAME=@szCharName;
	SET @del_error2 = @@ERROR;
	
	DELETE FROM tblWS_MEMO   WHERE txtNAME=@szCharName;
	SET @del_error3 = @@ERROR;

	DELETE FROM tblWS_ClanCHAR WHERE txtCharNAME=@szCharName;
	SET @del_error4 = @@ERROR;
	
	IF @del_error1 = 0 AND @del_error2 = 0 AND @del_error3 = 0 AND @del_error4 = 0
	BEGIN
		COMMIT TRAN del_char;
		RETURN 0;
	END
	
	ROLLBACK TRAN del_char;
	RETURN -2;





GO
/****** Object:  StoredProcedure [dbo].[ws_ClanBinUPDATE]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_ClanBinUPDATE    Script Date: 10/24/2005 4:10:57 PM ******/


CREATE PROCEDURE [dbo].[ws_ClanBinUPDATE]
	@iClanID	int,
	@binDAT	binary(1024)
AS
	BEGIN TRAN upt_data

	UPDATE tblWS_CLAN SET binDATA=@binDAT WHERE intID = @iClanID;

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN upt_data;
		RETURN 0;
	END
	
	COMMIT TRAN upt_data;
	RETURN 1;

GO
/****** Object:  StoredProcedure [dbo].[ws_ClanCharADD]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanCharADD    Script Date: 10/24/2005 4:10:57 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanCharADD]
	@szCharName	nchar(30),
	@iClanID	int,
	@iClanPOS	int
AS
	SELECT intClanID FROM tblWS_ClanCHAR where txtCharNAME=@szCharName;
	IF @@ROWCOUNT >= 1
		RETURN -1;
		
	BEGIN TRAN ins_char
	INSERT tblWS_ClanCHAR (txtCharNAME, intClanID, intPOS ) VALUES( @szCharName, @iClanID, @iClanPOS );
		
	IF @@ERROR = 0
	BEGIN
		COMMIT TRAN ins_char;
		RETURN 0;
	END
	
	ROLLBACK TRAN ins_char;
	RETURN -2;






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanCharADJ]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanCharADJ    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanCharADJ]
	@szCharName	nchar(30),
	@iAdjPoint	int,
	@iAdjPos	int
AS
	DECLARE	@iCurPoint	int;
	DECLARE	@iCurPos	int;
	
	SELECT @iCurPoint=intPOINT, @iCurPos=intPOS FROM tblWS_ClanCHAR where txtCharNAME=@szCharName;
	IF @@ROWCOUNT <> 1
		RETURN -1;
		
	BEGIN TRAN upd_char
	SET @iCurPoint = @iCurPoint + @iAdjPoint;
	SET @iCurPos   = @iCurPos	+ @iAdjPos;
	
	UPDATE tblWS_ClanCHAR SET intPOINT=@iCurPoint, intPOS=@iCurPos where txtCharNAME=@szCharName;
		
	IF @@ERROR = 0
	BEGIN
		COMMIT TRAN upd_char;
		RETURN 0;
	END
	
	ROLLBACK TRAN upd_char;
	RETURN -2;






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanCharALL]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanCharALL    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanCharALL]
	@iClanID	int
AS
	SELECT txtCharNAME, intPOINT, intPOS from tblWS_ClanCHAR where intClanID = @iClanID;
	-- RETURN @@ROWCOUNT;





GO
/****** Object:  StoredProcedure [dbo].[ws_ClanCharDEL]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanCharDEL    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanCharDEL]
	@szCharName	nchar(30)
AS
	SELECT intClanID FROM tblWS_ClanCHAR where txtCharNAME=@szCharName;
	IF @@ROWCOUNT < 1
		RETURN -1;		-- not found
		
	BEGIN TRAN del_char
	DELETE from tblWS_ClanCHAR where txtCharNAME = @szCharName;
		
	IF @@ERROR = 0
	BEGIN
		COMMIT TRAN del_char;
		RETURN 0;
	END
	
	ROLLBACK TRAN del_char;
	RETURN -2;			-- db error






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanCharGET]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanCharGET    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanCharGET]
	@szCharName	nchar(30)
AS
	SELECT intClanID, intPOINT, intPOS from tblWS_ClanCHAR where txtCharNAME = @szCharName;






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanDELETE]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanDELETE    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanDELETE]
	@szClanName	nvarchar(20)
AS
	DECLARE @del_error1 int;
	DECLARE @del_error2 int;
	
	DECLARE @iClanID	int;
	
	-- 삭제된 클렌ID얻기
	SELECT @iClanID=intID from tblWS_CLAN where txtNAME = @szClanName;
	IF @@ROWCOUNT <= 0 
		RETURN -1;
		
	BEGIN TRAN del_clan
	
	DELETE from tblWS_ClanCHAR where intClanID = @iClanID
	SET @del_error1 = @@ERROR;
		
	DELETE from tblWS_CLAN where intID = @iClanID;--txtNAME = @szClanName;
	SET @del_error2 = @@ERROR;
		
	IF @del_error1 = 0 AND @del_error2 = 0
	BEGIN
		COMMIT TRAN del_clan;
		SELECT @iClanID;
		RETURN 0;
	END
	
	ROLLBACK TRAN del_clan
	RETURN -2;






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanINSERT]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanINSERT    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanINSERT]
	@szClanName	nvarchar(20),
	@szClanDesc	nvarchar(255),
	@iMark1	int,
	@iMark2	int
AS
	SELECT intID FROM tblWS_CLAN WHERE txtNAME=@szClanName;
	IF @@ROWCOUNT >= 1
		RETURN -1;
	
	BEGIN TRAN ins_clan
	INSERT tblWS_CLAN (txtNAME, txtDESC, intMarkIdx1, intMarkIdx2) VALUES(
				@szClanName,
				@szClanDesc,
				@iMark1,
				@iMark2 );

	IF @@ERROR = 0
	BEGIN
		COMMIT TRAN ins_clan;
		SELECT intID FROM tblWS_CLAN WHERE txtNAME=@szClanName;
		RETURN 0;
	END
	
	ROLLBACK TRAN ins_clan
	RETURN -2;






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanMarkUPDATE]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/****** Object:  Stored Procedure dbo.ws_ClanMarkUPDATE    Script Date: 10/24/2005 4:10:58 PM ******/



CREATE   PROCEDURE [dbo].[ws_ClanMarkUPDATE]
	@iClanID	int,
	@iDataCRC	int,
	@iDataLEN	int,
	@binDATA	binary(1024)
AS
	BEGIN TRAN upt_mark

	DECLARE @dateCur	datetime;
	DECLARE @intRowCount int ;

	SET @dateCur = getdate();

	UPDATE tblWS_CLAN SET intMarkCRC=@iDataCRC, intMarkLEN=@iDataLEN, binMARK=@binDATA, dateMarkREG=@dateCur  
	WHERE intID = @iClanID ;

	set @intRowCount = @@ROWCOUNT

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN upt_mark;
		RETURN -1;
	END
	
	COMMIT TRAN upt_mark;
	RETURN @intRowCount;






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanMOTD]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanMOTD    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanMOTD]
	@iClanID	int,
	@szMessage	nvarchar(368)
AS

	BEGIN TRAN upd_clan
	
	UPDATE tblWS_CLAN SET txtMSG=@szMessage where intID = @iClanID;
		
	IF @@ERROR = 0
	BEGIN
		COMMIT TRAN upd_clan;
		RETURN 0;
	END
	
	ROLLBACK TRAN upd_clan
	RETURN -1;






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanSELECT]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanSELECT    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanSELECT]
	@iClanID	int
AS
	SELECT * from tblWS_CLAN where intID = @iClanID;






GO
/****** Object:  StoredProcedure [dbo].[ws_ClanSLOGAN]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_ClanSLOGAN    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_ClanSLOGAN]
	@iClanID	int,
	@szMessage	nvarchar(255)
AS

	BEGIN TRAN upd_clan
	
	UPDATE tblWS_CLAN SET txtDESC=@szMessage where intID = @iClanID;
		
	IF @@ERROR = 0
	BEGIN
		COMMIT TRAN upd_clan;
		RETURN 0;
	END
	
	ROLLBACK TRAN upd_clan
	RETURN -1;





GO
/****** Object:  StoredProcedure [dbo].[ws_ClanUPDATE]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_ClanUPDATE    Script Date: 10/24/2005 4:10:57 PM ******/




--Create Proc

CREATE PROCEDURE [dbo].[ws_ClanUPDATE]
	@iClanID	int,
	@szField	varchar(20),
	@iAdjValue	int
AS
	DECLARE	@szQry varchar(500)
	
	SET @szQry = 'UPDATE tblWS_CLAN SET ' + @szField + ' = ' + @szField + ' + ' + cast(@iAdjValue as varchar) + ' WHERE intID= ' + cast ( @iClanID as varchar )
	
	BEGIN TRAN upt_clan
	EXEC (  @szQry )
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN upt_clan;
		RETURN 0;
	END
	
	COMMIT TRAN upt_clan;
	
	SET @szQry = 'SELECT ' + @szField + ' FROM tblWS_CLAN WHERE intID= ' + cast ( @iClanID as varchar )
	EXEC ( @szQry  )
	RETURN 1;





GO
/****** Object:  StoredProcedure [dbo].[ws_CreateCHAR]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_CreateCHAR    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_CreateCHAR]
	@szAccount	nvarchar(20),
	@szCharName	nvarchar(30),
	@bbBE		binary(96),
	@bbBI		binary,
	@bbBA		binary,
	@bbGA		binary,
	@bbSA		binary,
	@bbINV	binary,
	@bbQD		binary,
	@bbHI		binary
AS
	INSERT tblGS_AVATAR (txtACCOUNT, txtNAME, binBasicE, binBasicI, binBasicA, binGrowA, binSkillA, blobINV, blobQUEST, binHotICON) VALUES(
			@szAccount,
			@szCharName,
			@bbBE,
			@bbBI,
			@bbBA,
			@bbGA,
			@bbSA,
			@bbINV,
			@bbQD,
			@bbHI )
GO
/****** Object:  StoredProcedure [dbo].[ws_DeleteCHAR]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_DeleteCHAR    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_DeleteCHAR]
	@szCharName	nvarchar(30),
	@iCharID	int
AS
	DELETE FROM tblWS_FRIEND WHERE intCharID=@iCharID;
	DELETE FROM tblGS_AVATAR WHERE txtNAME=@szCharName;
	DELETE FROM tblWS_MEMO   WHERE txtNAME=@szCharName;





GO
/****** Object:  StoredProcedure [dbo].[ws_DeleteUnregCHAR]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_DeleteUnregCHAR    Script Date: 10/24/2005 4:10:58 PM ******/



CREATE PROCEDURE [dbo].[ws_DeleteUnregCHAR] 
@txtUnregAccount nvarchar( 20 )
AS

DECLARE @txtNAME nvarchar(30)
DECLARE @intCharID int

DECLARE tblGS_AVATAR_cursor CURSOR FOR
select  txtNAME, intCharID from tblGS_AVATAR where txtACCOUNT=@txtUnregAccount

OPEN tblGS_AVATAR_cursor 

FETCH NEXT FROM tblGS_AVATAR_cursor INTO @txtNAME, @intCharID
WHILE @@FETCH_STATUS = 0
BEGIN
	-- delete for Clan
	delete from tblWS_CLANCHAR where txtCharNAME=@txtNAME

	-- delete for Memo
	delete from tblWS_MEMO where txtNAME=@txtNAME

	-- delete for Friend
	delete from tblWS_FRIEND where intCharID=@intCharID
	
	FETCH NEXT FROM tblGS_AVATAR_cursor INTO @txtNAME, @intCharID
END

CLOSE tblGS_AVATAR_cursor
DEALLOCATE tblGS_AVATAR_cursor

-- delete for Bank
delete from tblGS_BANK where txtACCOUNT=@txtUnregAccount

-- delete for avatar
delete from tblGS_AVATAR where txtACCOUNT=@txtUnregAccount




GO
/****** Object:  StoredProcedure [dbo].[ws_DelMEMO]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_DelMEMO    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_DelMEMO]
	@szName	nvarchar(30),
	@nCnt		int
AS
	DELETE FROM tblWS_MEMO WHERE (intSN IN (SELECT TOP  5  intSN FROM tblWS_MEMO WHERE txtNAME=@szName ORDER BY dwDATE ASC))





GO
/****** Object:  StoredProcedure [dbo].[ws_GetCharID]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_GetCharID    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_GetCharID]
	@szCharName	nvarchar(30)
AS
	SELECT intCharID FROM  tblGS_AVATAR WHERE txtNAME=@szCharName;





GO
/****** Object:  StoredProcedure [dbo].[ws_GetCharLIST]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.ws_GetCharLIST    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_GetCharLIST]
@szAccount	nvarchar(30)
AS
	SELECT txtNAME, binBasicE, binBasicI, binGrowA, dwDelTIME FROM tblGS_AVATAR WHERE txtACCOUNT=@szAccount





GO
/****** Object:  StoredProcedure [dbo].[ws_GetFRIEND]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_GetFRIEND    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_GetFRIEND]
	@iCharIDX	int
AS
	SELECT intFriendCNT, blobFRIENDS FROM tblWS_FRIEND WHERE intCharID=@iCharIDX





GO
/****** Object:  StoredProcedure [dbo].[ws_GetMEMO]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_GetMEMO    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_GetMEMO]
	@szName	nvarchar(30)
AS
	SELECT TOP 5  dwDATE, txtFROM, txtMEMO FROM tblWS_MEMO WHERE txtNAME=@szName ORDER BY dwDATE ASC





GO
/****** Object:  StoredProcedure [dbo].[ws_SelectCHAR]    Script Date: 5/9/2018 10:07:20 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.ws_SelectCHAR    Script Date: 10/24/2005 4:10:58 PM ******/




CREATE PROCEDURE [dbo].[ws_SelectCHAR]
	@szCharName	nvarchar(30)
AS
	SELECT txtACCOUNT, binBasicE, intCharID FROM tblGS_AVATAR WHERE txtNAME=@szCharName





GO
USE [master]
GO
ALTER DATABASE [SHO] SET  READ_WRITE 
GO
