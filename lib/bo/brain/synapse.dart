class Synapse {
  int? _source;
  int? _target;
  double? _ratio;

  int inputsLimit = 0;
  int outputsLimit = 0;
  int internalLimit = 0;

  Synapse(double ratio, {int? source, int? target}) {
    _ratio = ratio;
    _source = (source != null) ? source : 0;
    _target = (target != null) ? target : 0;
  }

  @override
  toString() {
    return "$_source*$_ratio->$_target";
  }

  setTippingPoints(int inputs, int internal, int outputs) {
    inputsLimit = inputs;
    internalLimit = inputsLimit + internal;
    outputsLimit = internalLimit + outputs;
  }

  int getSource() {
    return _source!; //scale(_source!, 0, internalLimit);
  }

  int getTarget() {
    return _target!; //scale(_target!, inputsLimit, outputsLimit);
  }

  double getRatio() {
    return _ratio!;
  }
}
