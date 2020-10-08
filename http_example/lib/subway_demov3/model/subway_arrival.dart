class SubwayArrival {
  int _rowNum;
  String _subwayId;
  String _trainLineName;
  String _subwayHeading;
  String _arvlMsg2;

  SubwayArrival(this._rowNum, this._subwayId, this._trainLineName,
      this._subwayHeading, this._arvlMsg2);

  int get rowNum => _rowNum;
  String get subwayId => _subwayId;
  String get trainLineName => _trainLineName;
  String get subwayHeading => _subwayHeading;
  String get arvlMsg2 => _arvlMsg2;
}
