import 'package:flutter/material.dart';
import '../models/produto_model.dart';
import '../services/produto_banco.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Produto> _produtos = [];

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final produtos = await ProdutoBanco.instance.getProdutos();
    setState(() {
      _produtos = produtos;
    });
  }

  Future<void> _guardarProduto() async {
    if (_nomeController.text.isEmpty || _valorController.text.isEmpty) return;

    final produto = Produto(
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      categoria: _categoriaController.text,
      valor: double.tryParse(_valorController.text) ?? 0.0,
    );

    await ProdutoBanco.instance.insertProduto(produto);
    
    _nomeController.clear();
    _descricaoController.clear();
    _categoriaController.clear();
    _valorController.clear();
    
    Navigator.pop(context); // Fecha o modal
    _carregarProdutos();
  }

  Future<void> _apagarProduto(int id) async {
    await ProdutoBanco.instance.deleteProduto(id);
    _carregarProdutos();
  }

  void _mostrarFormularioCadastro() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16, left: 16, right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _categoriaController,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarProduto,
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produtos'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(produto.nome),
              subtitle: Text('${produto.categoria} - R\$ ${produto.valor.toStringAsFixed(2)}\n${produto.descricao}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _apagarProduto(produto.id!),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormularioCadastro,
        child: const Icon(Icons.add),
      ),
    );
  }
}