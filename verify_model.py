import coremltools as ct

# Path to your Core ML model
mlmodel_path = "/Users/hasan/Documents/capstone/eggvision/eggvision/keras_model.mlmodel"

# Load the model
try:
    model = ct.models.MLModel(mlmodel_path)

    # Print model metadata
    print("✅ Model Name:", model.get_spec().description.metadata.shortDescription)
    print("✅ Model Inputs:", model.input_description)
    print("✅ Model Outputs:", model.output_description)
    print("✅ Input Shape:", model.get_spec().description.input)
    print("✅ Output Shape:", model.get_spec().description.output)
    print("✅ Model Specification:", model.get_spec())

except Exception as e:
    print(f"❌ Error loading model: {e}")

