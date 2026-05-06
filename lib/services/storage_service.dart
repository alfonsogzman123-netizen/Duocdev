class StorageService {
  Future<String> uploadFilePlaceholder() async {
    // MVP: la subida real se implementara con almacenamiento propio/backend.
    return 'demo://uploaded-file';
  }

  Future<String> extractTextPlaceholder() async {
    // MVP: la extraccion real de PDF/DOCX/PPTX queda para produccion.
    return 'Texto extraido demo';
  }
}
